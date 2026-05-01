// https://api.open-meteo.com/v1/forecast?latitude=-8.76&longitude=-63.90&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto request example

import 'dart:convert';

import 'package:climtech/domain/models/local_model.dart';
import 'package:http/http.dart' as http;

Future<LocalModel> buscarLocal({
  required double lat,
  required double lon,
}) async {
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto&model=ecmwf',
  );

  final resposta = await http.get(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (resposta.statusCode != 200) {
    return LocalModel(hourly: [], local: Local());
  }

  final body = jsonDecode(resposta.body)['hourly'];

  LocalModel localModel = LocalModel.fromJson(body, lat, lon);

  return localModel;
}
