import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:climtech/domain/models/temperatura_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../domain/models/local_model_modal.dart';

class HomeViewmodel extends ChangeNotifier {
  // exibe a tela de carregamento
  bool isLoading = true;

  // lista contendo todos os dados meteorologicos com base na localização selecionada/atual
  LocalModel listaCompleta = LocalModel(
    temperaturaModel: TemperaturaModel(hourly: []),
  );

  // lista com apenas os dados meteorologicos do dia selecionado
  LocalModel listaHorarioDiaSelecionado = LocalModel(
    cidade: 'Carregando...',
    siglaEstado: '',
    temperaturaModel: TemperaturaModel(hourly: []),
  );

  // variaveis e getters para consulta rapida
  int? temperaturaAgora;
  int? horaAtual;
  int? probabilidadeChuvaAtual;
  DateTime get pegarDiaAtual {
    if (listaHorarioDiaSelecionado.temperaturaModel.hourly.isEmpty) {
      return DateTime.now();
    }
    return listaHorarioDiaSelecionado.temperaturaModel.hourly[0].data;
  }

  // executado quando o app inicia, carrega os dados baseado na localização atual
  Future<void> carregarDadosLocalAtual(DateTime time) async {
    isLoading = true;
    notifyListeners();

    await pegarlocalAtual();

    try {
      listaCompleta = await buscarDados(
        lat: listaCompleta.latitude ?? 0,
        lon: listaCompleta.longitude ?? 0,
      );

      filtarDia(time);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // quando um outro dia é selecionado no modal calendario esse método é chamado
  void filtarDia(DateTime diaSelecionado) {
    final filtrado = listaCompleta.temperaturaModel.hourly.where((item) {
      return item.data.year == diaSelecionado.year &&
          item.data.month == diaSelecionado.month &&
          item.data.day == diaSelecionado.day;
    }).toList();

    listaHorarioDiaSelecionado = LocalModel(
      cidade: listaCompleta.cidade,
      siglaEstado: listaCompleta.siglaEstado,
      latitude: listaCompleta.latitude,
      longitude: listaCompleta.longitude,

      temperaturaModel: TemperaturaModel(hourly: filtrado),
    );

    atualizarClimaAtual();
    notifyListeners();
  }

  // atribui valor a algumas variaveis para facilitar sua consulta
  void atualizarClimaAtual() {
    if (listaHorarioDiaSelecionado.temperaturaModel.hourly.isEmpty) return;

    final agora = DateTime.now();
    horaAtual = agora.hour;

    final itemAtual = listaHorarioDiaSelecionado.temperaturaModel.hourly
        .firstWhere(
          (item) => item.data.hour == horaAtual,
          orElse: () =>
              listaHorarioDiaSelecionado.temperaturaModel.hourly.first,
        );

    temperaturaAgora = itemAtual.temperatura;
    probabilidadeChuvaAtual = itemAtual.probabilidadeDeChuva;

    notifyListeners();
  }

  // pega a localização atual do dispositivo
  Future<void> pegarlocalAtual() async {
    try {
      Position posicao = await _posicaoAtual();
      listaCompleta.latitude = posicao.latitude;
      listaCompleta.longitude = posicao.longitude;
    } catch (e) {
      return print(e.toString());
    }
  }

  // checa as permições e faz a busca pela localização
  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Ative a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('altorize o acesso a localização no smartphone');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('altorize o acesso a localização no smartphone');
    }

    return Geolocator.getCurrentPosition();
  }

  // executa quando um dia é selecionado no calendario
  Future<void> mudarDia(DateTime time) async {
    isLoading = true;
    notifyListeners();
    try {
      filtarDia(time);
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
