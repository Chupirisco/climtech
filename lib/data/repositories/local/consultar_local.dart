// https://api.open-meteo.com/v1/forecast?latitude=-8.76&longitude=-63.90&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto request example

import 'dart:convert';

import 'package:climtech/domain/models/temperatura_model.dart';
import 'package:http/http.dart' as http;

import '../../../domain/models/local_model.dart';

Future<LocalModel> buscarDados({
  required double lat,
  required double lon,
}) async {
  try {
    final localInfo = await obterCidadeEstado(lat, lon);

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto&model=ecmwf',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar clima');
    }

    final body = jsonDecode(resposta.body)['hourly'];

    final temperaturaModel = TemperaturaModel.fromJson(body, lat, lon);

    return LocalModel(
      cidade: localInfo['cidade'],
      siglaEstado: localInfo['estado'],
      latitude: lat,
      longitude: lon,
      temperaturaModel: temperaturaModel,
    );
  } catch (e) {
    print('Erro geral: $e');

    return LocalModel(
      cidade: 'Desconhecida',
      siglaEstado: '??',
      latitude: lat,
      longitude: lon,
      temperaturaModel: TemperaturaModel(hourly: []),
    );
  }
}

Future<Map<String, String>> obterCidadeEstado(double lat, double lon) async {
  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1',
  );

  final response = await http.get(
    url,
    headers: {
      'User-Agent': 'climtech-app/1.0 (yurigabrielsouza10@gmail.com)',
      'Accept-Language': 'pt-BR',
    },
  );
  if (response.statusCode != 200) {
    return {'cidade': 'Desconhecida', 'estado': '??'};
  }

  final data = jsonDecode(response.body);
  final addr = data['address'];

  final cidade =
      addr['city'] ??
      addr['town'] ??
      addr['village'] ??
      addr['municipality'] ??
      'Desconhecida';

  String estado = '??';

  if (addr['ISO3166-2-lvl4'] != null) {
    estado = addr['ISO3166-2-lvl4'].split('-')[1];
  }

  return {'cidade': cidade, 'estado': estado};
}
