import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:climtech/domain/models/local_model.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  LocalModel listaHorarios = LocalModel(hourly: []);
  LocalModel listaHorarioDiaSelecionado = LocalModel(hourly: []);

  int? get pegarTemperaturaAtual {
    if (listaHorarioDiaSelecionado.hourly.isEmpty) return null;

    final agora = DateTime.now();

    final maisProximo = listaHorarioDiaSelecionado.hourly.reduce((a, b) {
      final diffA = (a.data.difference(agora)).abs();
      final diffB = (b.data.difference(agora)).abs();
      return diffA < diffB ? a : b;
    });

    return maisProximo.temperatura;
  }

  void carregarLocal() async {
    listaHorarios = await buscarLocal();
    mudarDiaSelecionado();
    notifyListeners();
  }

  void mudarDiaSelecionado() {
    final agora = DateTime.now();

    final filtrado = listaHorarios.hourly.where((item) {
      return item.data.year == agora.year &&
          item.data.month == agora.month &&
          item.data.day == agora.day;
    }).toList();

    listaHorarioDiaSelecionado = LocalModel(
      nome: listaHorarios.nome,
      latitude: listaHorarios.latitude,
      longitude: listaHorarios.longitude,
      hourly: filtrado,
    );

    notifyListeners();
  }
}
