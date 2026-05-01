class LocalModel {
  Local local;
  List<TemperaturaEClima> hourly;

  LocalModel({required this.hourly, required this.local});

  factory LocalModel.fromJson(
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

    return LocalModel(
      local: Local(
        cidade: 'Não encontrado',
        estado: 'Não encontrado',
        latitude: lat,
        longitude: lon,
      ),
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

class Local {
  String? cidade;
  String? estado;
  double? latitude;
  double? longitude;

  Local({this.cidade, this.estado, this.latitude, this.longitude});
}
