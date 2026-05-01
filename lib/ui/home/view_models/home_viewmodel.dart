import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:climtech/domain/models/local_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeViewmodel extends ChangeNotifier {
  bool isLoading = true;

  LocalModel listaHorarios = LocalModel(hourly: [], local: Local());

  LocalModel listaHorarioDiaSelecionado = LocalModel(
    hourly: [],
    local: Local(),
  );
  int? temperaturaAgora;
  int? horaAtual;
  int? probabilidadeChuvaAtual;

  Local localSelecionado = Local();

  DateTime get pegarDiaAtual {
    if (listaHorarioDiaSelecionado.hourly.isEmpty) {
      return DateTime.now();
    }
    return listaHorarioDiaSelecionado.hourly[0].data;
  }

  // executado quando o app inicia, carrega os dados baseado na localização atual
  Future<void> carregarLocalSelecionado(DateTime time) async {
    isLoading = true;
    notifyListeners();

    // pegarlocalAtual já chama obterCidade internamente
    await pegarlocalAtual();

    try {
      listaHorarios = await buscarLocal(
        lat: localSelecionado.latitude ?? 0,
        lon: localSelecionado.longitude ?? 0,
      );

      // Passa cidade e estado para listaHorarios.local
      listaHorarios.local.cidade = localSelecionado.cidade;
      listaHorarios.local.estado = localSelecionado.estado;

      filtarDia(time);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filtarDia(DateTime diaSelecionado) {
    final filtrado = listaHorarios.hourly.where((item) {
      return item.data.year == diaSelecionado.year &&
          item.data.month == diaSelecionado.month &&
          item.data.day == diaSelecionado.day;
    }).toList();

    listaHorarioDiaSelecionado = LocalModel(
      local: Local(
        cidade: listaHorarios.local.cidade,
        estado: listaHorarios.local.estado,
        latitude: listaHorarios.local.latitude,
        longitude: listaHorarios.local.longitude,
      ),
      hourly: filtrado,
    );

    atualizarClimaAtual();
    notifyListeners();
  }

  void atualizarClimaAtual() {
    if (listaHorarioDiaSelecionado.hourly.isEmpty) return;

    final agora = DateTime.now();
    horaAtual = agora.hour;

    // ← orElse evita StateError se a hora não for encontrada
    final itemAtual = listaHorarioDiaSelecionado.hourly.firstWhere(
      (item) => item.data.hour == horaAtual,
      orElse: () => listaHorarioDiaSelecionado.hourly.first,
    );

    temperaturaAgora = itemAtual.temperatura;
    probabilidadeChuvaAtual = itemAtual.probabilidadeDeChuva;

    notifyListeners();
  } // pega a localização atual do dispositivo

  Future<void> pegarlocalAtual() async {
    try {
      Position posicao = await _posicaoAtual();
      localSelecionado.latitude = posicao.latitude;
      localSelecionado.longitude = posicao.longitude;

      await obterCidade(
        localSelecionado.latitude ?? 0,
        localSelecionado.longitude ?? 0,
      );
    } catch (e) {
      return print(e.toString());
    }
  }

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

  Future<void> obterCidade(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        localSelecionado.cidade = place.locality?.isNotEmpty == true
            ? place.locality!
            : place.subAdministrativeArea?.isNotEmpty == true
            ? place.subAdministrativeArea!
            : place.subLocality?.isNotEmpty == true
            ? place.subLocality!
            : 'Cidade desconhecida';

        localSelecionado.estado =
            place.administrativeArea ?? 'Estado desconhecido';
        return;
      }

      localSelecionado.cidade = 'Cidade desconhecida';
      localSelecionado.estado = 'Estado desconhecido';
    } catch (e) {
      print('Erro ao obter cidade: $e');
      localSelecionado.cidade = 'Cidade desconhecida';
      localSelecionado.estado = 'Estado desconhecido';
    }
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
