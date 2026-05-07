import 'dart:async';

import 'package:climtech/utils/texto_formatado.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local/consultar_local.dart';
import '../../../domain/models/estados_brasileiros_model.dart';

class SelectLocationViewmodel extends ChangeNotifier {
  final allStates = BrazilianState.allStates;

  // ─── Seleções finais ───────────────────────────────────────────────────────
  BrazilianState? _selectedState;
  String? _selectedCity;
  BrazilianState? _nomeEstadoSelecionado;

  BrazilianState? get selectedState => _selectedState;

  String? get selectedCity => _selectedCity;
  BrazilianState? get nomeEstadoSelecionado => _nomeEstadoSelecionado;

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
      final results = await fetchCities(_selectedState!.code);
      final q = query.toLowerCase();

      // aqui faz a busca
      _citySuggestions = results
          .where((c) => c.toLowerCase().contains(q))
          .take(5)
          .toList();
      _cityLoading = false;
      notifyListeners();
    });
  }

  // Confirma a seleção de uma cidade.
  void selectCity(String city, String estado) {
    _selectedCity = city;
    _nomeEstadoSelecionado = allStates.firstWhere((e) => e.name == estado);
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
