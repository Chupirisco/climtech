import 'package:climtech/routing/route.dart';
import 'package:climtech/ui/confg/view_models/tema_viewmodel.dart';
import 'package:climtech/ui/core/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeController())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: AppTheme.temaClaro,
        darkTheme: AppTheme.temaEscuro,

        // configurar aqui pra mudar o tema
        themeMode: themeController.themeMode,

        // define a imagem de fundo
        initialRoute: '/',

        routes: AppRoute.rotas(),
      ),
    );
  }
}
