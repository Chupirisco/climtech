import 'package:climtech/routing/route.dart';
import 'package:climtech/ui/core/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.temaClaro,
      darkTheme: AppTheme.temaEscuro,

      // configurar aqui pra mudar o tema
      themeMode: ThemeMode.light,

      // define a imagem de fundo
      initialRoute: '/',

      routes: AppRoute.rotas(),
    );
  }
}
