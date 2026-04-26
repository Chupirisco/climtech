import 'package:climtech/data/services/stored_theme.dart';
import 'package:climtech/routing/route.dart';
import 'package:climtech/ui/confg/view_models/tema_viewmodel.dart';
import 'package:climtech/ui/core/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final controller = ThemeController(StoreThemePreferences());
            controller.loadTheme();
            return controller;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.temaClaro,
      darkTheme: AppTheme.temaEscuro,

      themeMode: themeController.themeMode,

      initialRoute: '/',
      routes: AppRoute.rotas(),
    );
  }
}
