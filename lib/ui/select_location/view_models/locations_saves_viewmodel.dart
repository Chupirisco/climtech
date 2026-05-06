import 'package:climtech/data/services/stored_location.dart';
import 'package:climtech/domain/models/locais_salvos_model.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local/consultar_local.dart';

class LocationsSavesViewmodel extends ChangeNotifier {
  List<LocaisSalvos> locaisSalvos = [];

  final _saves = StoredLocation();

  void adicionarLocal(String cidade, String estado, String sigla) async {
    final result = await buscarDadosPorNome(cidade: cidade, estado: estado);

    if (result == null) {
      return;
    }

    result.estado = sigla;

    locaisSalvos.add(result);

    notifyListeners();
  }

  Future<void> carregarLocaisSalvos() async {
    await _saves.loadLocations();

    final result = _saves.converterLista();

    locaisSalvos.clear();
    final futures = result.map(
      (e) => buscarFavoritos(lat: e['lat']!, lon: e['lon']!),
    );

    final responses = await Future.wait(futures);

    locaisSalvos = responses.whereType<LocaisSalvos>().toList();

    notifyListeners();

    notifyListeners();
  }

  void removerLocal(int index) {
    _saves.removeLocation(index);

    locaisSalvos.removeAt(index);

    notifyListeners();
  }
}
