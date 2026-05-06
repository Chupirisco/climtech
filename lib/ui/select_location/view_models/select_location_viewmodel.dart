import 'dart:async';

import 'package:climtech/utils/texto_formatado.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local/consultar_local.dart';

class SelectLocationViewmodel extends ChangeNotifier {
  // ─── Seleções finais ───────────────────────────────────────────────────────
  BrazilianState? _selectedState;
  String? _selectedCity;
  String? _nomeEstadoSelecionado;

  BrazilianState? get selectedState => _selectedState;

  String? get selectedCity => _selectedCity;
  String? get nomeEstadoSelecionado => _nomeEstadoSelecionado;

  // ─── Estados brasileiros ───────────────────────────────────────────────────
  static const List<BrazilianState> allStates = [
    BrazilianState(name: 'Acre', code: 'AC'),
    BrazilianState(name: 'Alagoas', code: 'AL'),
    BrazilianState(name: 'Amapá', code: 'AP'),
    BrazilianState(name: 'Amazonas', code: 'AM'),
    BrazilianState(name: 'Bahia', code: 'BA'),
    BrazilianState(name: 'Ceará', code: 'CE'),
    BrazilianState(name: 'Distrito Federal', code: 'DF'),
    BrazilianState(name: 'Espírito Santo', code: 'ES'),
    BrazilianState(name: 'Goiás', code: 'GO'),
    BrazilianState(name: 'Maranhão', code: 'MA'),
    BrazilianState(name: 'Mato Grosso', code: 'MT'),
    BrazilianState(name: 'Mato Grosso do Sul', code: 'MS'),
    BrazilianState(name: 'Minas Gerais', code: 'MG'),
    BrazilianState(name: 'Pará', code: 'PA'),
    BrazilianState(name: 'Paraíba', code: 'PB'),
    BrazilianState(name: 'Paraná', code: 'PR'),
    BrazilianState(name: 'Pernambuco', code: 'PE'),
    BrazilianState(name: 'Piauí', code: 'PI'),
    BrazilianState(name: 'Rio de Janeiro', code: 'RJ'),
    BrazilianState(name: 'Rio Grande do Norte', code: 'RN'),
    BrazilianState(name: 'Rio Grande do Sul', code: 'RS'),
    BrazilianState(name: 'Rondônia', code: 'RO'),
    BrazilianState(name: 'Roraima', code: 'RR'),
    BrazilianState(name: 'Santa Catarina', code: 'SC'),
    BrazilianState(name: 'São Paulo', code: 'SP'),
    BrazilianState(name: 'Sergipe', code: 'SE'),
    BrazilianState(name: 'Tocantins', code: 'TO'),
  ];

  // ─── Sugestões dos dropdowns ───────────────────────────────────────────────

  List<BrazilianState> _stateSuggestions = [];
  List<String> _citySuggestions = [];

  List<BrazilianState> get stateSuggestions => _stateSuggestions;
  List<String> get citySuggestions => _citySuggestions;

  // ─── Loading / overlay ─────────────────────────────────────────────────────

  bool _cityLoading = false;
  bool get cityLoading => _cityLoading;

  bool get cityEnabled => _selectedState != null;

  // ─── Debounce ──────────────────────────────────────────────────────────────

  Timer? _cityDebounce;

  // ─── Lógica de Estado ──────────────────────────────────────────────────────

  /// Filtra a lista de estados conforme o texto digitado.
  /// Retorna `true` se há sugestões, `false` se a lista ficou vazia.
  bool onStateQueryChanged(String query) {
    final q = normalizarTexto(query).trim();

    if (q.isEmpty) {
      _stateSuggestions = [];
      notifyListeners();
      return false;
    }

    _stateSuggestions = allStates
        .where((s) {
          final name = normalizarTexto(s.name);
          final code = s.code.toLowerCase();

          return name.startsWith(q) || code.startsWith(q);
        })
        .take(4)
        .toList();

    notifyListeners();
    return _stateSuggestions.isNotEmpty;
  }

  /// Confirma a seleção de um estado. Limpa cidade automaticamente.
  void selectState(BrazilianState state) {
    _selectedState = state;
    _selectedCity = null;
    _stateSuggestions = [];
    _citySuggestions = [];
    notifyListeners();
  }

  /// Limpa o estado selecionado (ex: usuário apagou o texto do campo).
  void clearState() {
    _selectedState = null;
    _selectedCity = null;
    _stateSuggestions = [];
    _citySuggestions = [];
    notifyListeners();
  }

  // ─── Lógica de Cidade ──────────────────────────────────────────────────────

  /// Inicia a busca de cidades com debounce.
  /// O overlay deve ser aberto pelo widget assim que este método for chamado
  /// (enquanto _cityLoading = true o dropdown mostra o spinner).
  void onCityQueryChanged(String query) {
    if (!cityEnabled) return;

    _cityDebounce?.cancel();

    if (query.trim().isEmpty) {
      _citySuggestions = [];
      _cityLoading = false;
      notifyListeners();
      return;
    }

    // Marca loading imediatamente para o widget abrir o overlay com spinner
    _cityLoading = true;
    notifyListeners();

    _cityDebounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await fetchCities(_selectedState!.code, query);

      _citySuggestions = results.take(4).toList();
      _cityLoading = false;
      notifyListeners();
    });
  }

  // Confirma a seleção de uma cidade.
  void selectCity(String city, String estado) {
    _selectedCity = city;
    _nomeEstadoSelecionado = estado;
    _citySuggestions = [];
    notifyListeners();
  }

  /// Limpa a cidade (ex: usuário apagou o texto).
  void clearCity() {
    _selectedCity = null;
    _citySuggestions = [];
    notifyListeners();
  }

  // ─── Reset geral ───────────────────────────────────────────────────────────

  void reset() {
    _cityDebounce?.cancel();
    _selectedState = null;
    _stateSuggestions = [];
    _citySuggestions = [];
    _cityLoading = false;
    notifyListeners();
  }
}

class BrazilianState {
  final String name;
  final String code;
  const BrazilianState({required this.name, required this.code});
}
