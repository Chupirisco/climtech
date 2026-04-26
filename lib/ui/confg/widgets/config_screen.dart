import 'package:flutter/material.dart';

import 'components.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: 20),
      children: [
        configCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text('Tema'), alternarTema(context)],
          ),
          backgroundColor: tema.onSecondary,
        ),
      ],
    );
  }
}
