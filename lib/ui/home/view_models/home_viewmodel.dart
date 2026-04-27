import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  String nomeLocal = 'Ouro Preto do Oeste - RO';

  void carregarLocal() {
    buscarLocal();
  }
}
