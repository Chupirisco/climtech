class LocalModel {
  String nome;
  double latitude;
  double longitude;

  List<TemperaturaEClima> hourly;
  List<TemperaturaEClima> daily;

  LocalModel({
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.hourly,
    required this.daily,
  });
}

class TemperaturaEClima {
  DateTime data;
  double temperatura;
  double probabilidadeDeChuva;

  TemperaturaEClima({
    required this.data,
    required this.temperatura,
    required this.probabilidadeDeChuva,
  });
}
