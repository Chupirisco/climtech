import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:climtech/domain/models/local_model.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  bool isLoading = true;

  LocalModel listaHorarios = LocalModel(hourly: []);

  LocalModel listaHorarioDiaSelecionado = LocalModel(hourly: []);
  int? temperaturaAgora;
  int? horaAtual;
  int? probabilidadeChuvaAtual;

  DateTime get pegarDiaAtual {
    if (listaHorarioDiaSelecionado.hourly.isEmpty) {
      return DateTime.now();
    }
    return listaHorarioDiaSelecionado.hourly[0].data;
  }

  Future<void> carregarLocal() async {
    isLoading = true;
    notifyListeners();

    try {
      listaHorarios = await buscarLocal();
      mudarDiaSelecionado();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void atualizarClimaAtual() {
    if (listaHorarioDiaSelecionado.hourly.isEmpty) return;

    final agora = DateTime.now();
    horaAtual = agora.hour;

    final itemAtual = listaHorarioDiaSelecionado.hourly.firstWhere(
      (item) => item.data.hour == horaAtual,
    );

    temperaturaAgora = itemAtual.temperatura;
    probabilidadeChuvaAtual = itemAtual.probabilidadeDeChuva;

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

    atualizarClimaAtual();

    notifyListeners();
  }
}
