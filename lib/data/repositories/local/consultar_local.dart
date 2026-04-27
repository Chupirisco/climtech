// https://api.open-meteo.com/v1/forecast?latitude=-8.76&longitude=-63.90&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto request example

import 'package:http/http.dart' as http;

Future<void> buscarLocal() async {
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=-8.76&longitude=-63.90&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,precipitation_probability&forecast_days=14&timezone=auto',
  );

  final resposta = await http.get(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  print(resposta.statusCode);
  print('===================================================');
}
