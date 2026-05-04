import 'package:climtech/domain/models/locais_salvos_model.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local/consultar_local.dart';

class LocationsSavesViewmodel extends ChangeNotifier {
  List<LocaisSalvos> locaisSalvos = [];

  double lat = 0;
  double lon = 0;

  void adicionarLocal(String cidade, String estado) async {
    final result = await buscarDadosPorNome(cidade: cidade, estado: estado);

    if (result == null) {
      return;
    }

    locaisSalvos.add(result);
    notifyListeners();
  }
}
