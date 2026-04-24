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
      themeMode: ThemeMode.system,

      home: Temporario(),
    );
  }
}

class Temporario extends StatelessWidget {
  const Temporario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/img/dark.png'),
          Center(child: Text("é isso", style: TextStyle(fontSize: 50))),
        ],
      ),
    );
  }
}
