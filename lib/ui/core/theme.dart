import 'package:climtech/utils/colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final temaClaro = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: Tema.temaClaro,
  );
  static final temaEscuro = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: Tema.temaEscuro,
  );
}
