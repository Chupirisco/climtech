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

class CidadesRepository {
  static const _baseUrl =
      'https://servicodados.ibge.gov.br/api/v1/localidades/municipios';

  Future<List<CidadeModel>> buscarPorNome(String query) async {
    final url = Uri.parse('$_baseUrl?nome=${Uri.encodeComponent(query)}');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar municípios: ${response.statusCode}');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => CidadeModel.fromJson(e)).take(5).toList();
  }
}

Future<List<String>> fetchCities(String stateCode, String query) async {
  // Simula latência de rede
  await Future.delayed(const Duration(milliseconds: 600));

  // TODO: substituir pelo endpoint real, ex.:
  //   https://servicodados.ibge.gov.br/api/v1/localidades/estados/$stateCode/municipios
  // e filtrar pelo query no retorno.

  const fakeCities = {
    'RO': [
      'Porto Velho',
      'Ji-Paraná',
      'Ariquemes',
      'Vilhena',
      'Cacoal',
      'Rolim de Moura',
      'Nova União',
      'Jaru',
    ],
    'SP': [
      'São Paulo',
      'Campinas',
      'Santos',
      'Sorocaba',
      'Ribeirão Preto',
      'São José dos Campos',
    ],
    'RJ': [
      'Rio de Janeiro',
      'Niterói',
      'Duque de Caxias',
      'Petrópolis',
      'Volta Redonda',
    ],
    'MG': [
      'Belo Horizonte',
      'Uberlândia',
      'Contagem',
      'Juiz de Fora',
      'Montes Claros',
    ],
  };

  final list =
      fakeCities[stateCode] ??
      ['(sem dados para $stateCode — conecte a API real)'];
  final q = query.toLowerCase();
  return list.where((c) => c.toLowerCase().contains(q)).take(8).toList();
}
