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

class CidadeModel {
  final String nome;
  final String uf;

  CidadeModel({required this.nome, required this.uf});

  /// Exibe como "Ouro Preto - MG"
  String get nomeCompleto => '$nome - $uf';

  factory CidadeModel.fromJson(Map<String, dynamic> json) {
    return CidadeModel(
      nome: json['nome'],
      uf: json['microrregiao']['mesorregiao']['UF']['sigla'],
    );
  }
}
