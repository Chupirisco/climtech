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
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDark ? 'assets/img/dark.png' : 'assets/img/light.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        );
      },
      routes: AppRoute.rotas(),
      initialRoute: '/',
    );
  }
}
