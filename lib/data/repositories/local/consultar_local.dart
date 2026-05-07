// https://api.open-meteo.com/v1/forecast?latitude=-8.76&longitude=-63.90&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto request example

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:climtech/data/services/stored_location.dart';
import 'package:climtech/domain/models/temperatura_model.dart';
import 'package:http/http.dart' as http;

import '../../../domain/models/locais_salvos_model.dart';
import '../../../domain/models/local_model_modal.dart';

Future<LocalModel> buscarDados({
  required double lat,
  required double lon,
}) async {
  try {
    final localInfo = await obterCidadeEstado(lat, lon);

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto',
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

Future<List<String>> fetchCities(String stateCode) async {
  final url = Uri.parse(
    'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$stateCode/municipios',
  );

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Erro ao buscar cidades: ${response.statusCode}');
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data.map((e) => e['nome'] as String).toList();
}

Future<LocaisSalvos?> buscarDadosPorNome({
  required String cidade,
  required String estado,
}) async {
  try {
    // 1. NOMINATIM → pegar lat/lon
    final urlGeo = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent("$cidade $estado Brasil")}&format=json&limit=1",
    );

    final geoResponse = await http.get(
      urlGeo,
      headers: {
        'User-Agent': 'climtech-app/1.0 (seuemail@email.com)',
        'Accept-Language': 'pt-BR',
      },
    );

    if (geoResponse.statusCode != 200) return null;

    final geoData = jsonDecode(geoResponse.body);

    if (geoData.isEmpty) return null;

    final geo = geoData[0];

    final lat = double.parse(geo['lat']);
    final lon = double.parse(geo['lon']);

    final urlWeather = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=precipitation_probability&timezone=auto",
    );

    final weatherResponse = await http.get(urlWeather);

    if (weatherResponse.statusCode != 200) return null;

    final weatherData = jsonDecode(weatherResponse.body);

    final current = weatherData['current_weather'];
    final hourly = weatherData['hourly'];

    final temperatura = current['temperature'].round();

    final now = DateTime.now();

    // listas
    final List times = hourly['time'];
    final List probs = hourly['precipitation_probability'];

    // encontrar índice correto
    int indexAtual = times.indexWhere((t) {
      final time = DateTime.parse(t);
      return time.year == now.year &&
          time.month == now.month &&
          time.day == now.day &&
          time.hour == now.hour;
    });

    // fallback seguro
    if (indexAtual == -1) {
      indexAtual = 0;
    }

    final probAgora = probs[indexAtual];

    final saves = StoredLocation();
    await saves.addLocation(lat, lon);

    return LocaisSalvos(
      cidade: cidade,
      estado: estado,
      temperaturaAtual: temperatura,
      probabilidadeDeChuva: probAgora,
    );
  } catch (e) {
    print('Erro: $e');
    return null;
  }
}

Future<LocaisSalvos?> buscarFavoritos({
  required double lat,
  required double lon,
}) async {
  try {
    final localInfo = await obterCidadeEstado(lat, lon);

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,precipitation_probability&current_weather=true&forecast_days=14&timezone=auto',
    );

    final weatherResponse = await http.get(url);

    if (weatherResponse.statusCode != 200) return null;

    final weatherData = jsonDecode(weatherResponse.body);

    final current = weatherData['current_weather'];
    final hourly = weatherData['hourly'];

    final temperatura = current['temperature'].round();

    final now = DateTime.now();

    // listas
    final List times = hourly['time'];
    final List probs = hourly['precipitation_probability'];

    // 🔥 encontrar índice correto
    int indexAtual = times.indexWhere((t) {
      final time = DateTime.parse(t);
      return time.year == now.year &&
          time.month == now.month &&
          time.day == now.day &&
          time.hour == now.hour;
    });

    // fallback seguro
    if (indexAtual == -1) {
      indexAtual = 0;
    }

    final probAgora = probs[indexAtual];
    return LocaisSalvos(
      cidade: localInfo['cidade']!,
      estado: localInfo['estado']!,
      temperaturaAtual: temperatura,
      probabilidadeDeChuva: probAgora,
    );
  } catch (e) {
    print('Erro geral: $e');

    return null;
  }
}

Future<LocalModel> buscarDadosPorNomeCompleto({
  required String cidade,
  required String estado,
}) async {
  try {
    // 1. NOMINATIM → pegar lat/lon
    final urlGeo = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent("$cidade $estado Brasil")}&format=json&limit=1",
    );

    final geoResponse = await http.get(
      urlGeo,
      headers: {
        'User-Agent': 'climtech-app/1.0 (seuemail@email.com)',
        'Accept-Language': 'pt-BR',
      },
    );

    if (geoResponse.statusCode != 200) {
      return LocalModel(temperaturaModel: TemperaturaModel(hourly: []));
    }

    final geoData = jsonDecode(geoResponse.body);

    if (geoData.isEmpty) {
      return LocalModel(temperaturaModel: TemperaturaModel(hourly: []));
    }

    final geo = geoData[0];

    final lat = double.parse(geo['lat']);
    final lon = double.parse(geo['lon']);

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto',
    );
    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar clima');
    }

    final body = jsonDecode(resposta.body)['hourly'];

    final temperaturaModel = TemperaturaModel.fromJson(body, lat, lon);

    return LocalModel(
      cidade: cidade,
      siglaEstado: estado,
      latitude: lat,
      longitude: lon,
      temperaturaModel: temperaturaModel,
    );
  } catch (e) {
    print('Erro: $e');
    return LocalModel(temperaturaModel: TemperaturaModel(hourly: []));
  }
}
