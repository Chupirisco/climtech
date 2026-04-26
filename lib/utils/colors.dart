import 'package:flutter/material.dart';

class CoresClaras {
  static const Color primaria = Color(0XFF000000);
  static final Color secundaria = const Color(
    0XFF3C3C43,
  ).withValues(alpha: 0.6);
  static final Color terceira = const Color(0XFF3C3C43).withValues(alpha: 0.3);
  static final Color quarta = const Color(0XFF3C3C43).withValues(alpha: 0.18);
}

class CoresEscuras {
  static const Color primaria = Color(0XFFFFFFFF);
  static final Color secundaria = const Color(
    0XFFEBEBF5,
  ).withValues(alpha: 0.6);
  static final Color terceira = const Color(0XFFEBEBF5).withValues(alpha: 0.3);
  static final Color quarta = const Color(0XFFEBEBF5).withValues(alpha: 0.18);
}

class Tema {
  static final temaClaro = ColorScheme.light(
    brightness: Brightness.light,

    surface: CoresEscuras.primaria,
    onSurface: CoresClaras.primaria,

    primary: CoresClaras.secundaria,
    onPrimary: CoresEscuras.secundaria,

    secondary: CoresClaras.terceira,
    onSecondary: CoresEscuras.terceira,

    tertiary: CoresClaras.quarta,
    onTertiary: CoresEscuras.quarta,

    error: Colors.redAccent,
    onError: Colors.red,
  );

  static final temaEscuro = ColorScheme.dark(
    brightness: Brightness.dark,

    surface: CoresClaras.primaria,
    onSurface: CoresEscuras.primaria,

    primary: CoresEscuras.secundaria,
    onPrimary: CoresClaras.secundaria,

    secondary: CoresEscuras.terceira,
    onSecondary: CoresClaras.terceira,

    tertiary: CoresEscuras.quarta,
    onTertiary: CoresClaras.quarta,

    error: Colors.redAccent,
    onError: Colors.red,
  );
}
