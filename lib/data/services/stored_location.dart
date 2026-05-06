import 'package:shared_preferences/shared_preferences.dart';

class StoredLocation {
  static const String _key = 'saved_locations';

  List<String> _savedLocations = [];

  List<String> get savedLocations => _savedLocations;

  // Carregar
  Future<void> loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    _savedLocations = prefs.getStringList(_key) ?? [];
  }

  // Salvar
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _savedLocations);
  }

  // Adicionar lat/lon
  Future<void> addLocation(double lat, double lon) async {
    final location = "$lat,$lon";
    await loadLocations();
    if (!_savedLocations.contains(location)) {
      _savedLocations.add(location);
      await _saveToStorage();
    }
  }

  // Remover
  Future<void> removeLocation(int index) async {
    await loadLocations();
    _savedLocations.removeAt(index);
    await _saveToStorage();
  }

  // Limpar tudo
  Future<void> clearLocations() async {
    _savedLocations.clear();
    await _saveToStorage();
  }

  List<Map<String, double>> converterLista() {
    return savedLocations.map((loc) {
      final parts = loc.split(',');
      return {'lat': double.parse(parts[0]), 'lon': double.parse(parts[1])};
    }).toList();
  }
}
