class TemperaturaModel {
  List<TemperaturaEClima> hourly;

  TemperaturaModel({required this.hourly});

  factory TemperaturaModel.fromJson(
    Map<String, dynamic> json,
    double lat,
    double lon,
  ) {
    List<TemperaturaEClima> lista = [];

    for (int i = 0; i < json['time'].length; i++) {
      lista.add(
        TemperaturaEClima(
          data: DateTime.parse(json['time'][i]),
          temperatura: (json['temperature_2m'][i] as num).floor(),
          probabilidadeDeChuva: json['precipitation_probability'][i],
        ),
      );
    }

    return TemperaturaModel(hourly: lista);
  }
}

class TemperaturaEClima {
  DateTime data;
  int temperatura;
  int probabilidadeDeChuva;

  TemperaturaEClima({
    required this.data,
    required this.temperatura,
    required this.probabilidadeDeChuva,
  });
}
