import 'package:climtech/data/services/stored_theme.dart';
import 'package:climtech/routing/route.dart';
import 'package:climtech/ui/confg/view_models/tema_viewmodel.dart';
import 'package:climtech/ui/core/theme.dart';
import 'package:climtech/ui/home/view_models/home_viewmodel.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null);
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
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
        ChangeNotifierProvider(create: (_) => SelectLocationViewmodel()),
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.temaClaro,
          darkTheme: AppTheme.temaEscuro,

          themeMode: themeController.themeMode,

          initialRoute: '/',
          routes: AppRoute.rotas(),
        );
      },
    );
  }
}
