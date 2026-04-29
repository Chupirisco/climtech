class LocalModel {
  String? nome = 'Ouro Preto do Oeste - RO';
  double? latitude = -8.752196;
  double? longitude = -63.93106;

  List<TemperaturaEClima> hourly;

  LocalModel({this.nome, required this.hourly, this.latitude, this.longitude});

  factory LocalModel.fromJson(Map<String, dynamic> json) {
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

    return LocalModel(
      nome: 'Ouro Preto do Oeste - RO',
      latitude: -10.7117,
      longitude: -62.255,
      hourly: lista,
    );
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
