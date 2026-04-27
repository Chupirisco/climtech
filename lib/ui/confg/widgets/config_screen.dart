import 'package:climtech/utils/estilos_pradroes.dart';
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
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: margem().right),
      children: [
        configCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Tema', style: estiloTexto(20)),
              alternarTema(context),
            ],
          ),
          backgroundColor: tema.onSecondary,
        ),
      ],
    );
  }
}
