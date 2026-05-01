import 'package:climtech/domain/models/temperatura_model.dart';

class LocalModel {
  String? cidade;
  String? siglaEstado;
  double? latitude;
  double? longitude;

  TemperaturaModel temperaturaModel;

  LocalModel({
    this.cidade,
    this.siglaEstado,
    this.latitude,
    this.longitude,
    required this.temperaturaModel,
  });
}
