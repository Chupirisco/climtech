import 'package:climtech/ui/confg/widgets/config_screen.dart';
import 'package:climtech/ui/home/widgets/home_screen.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class BuildAppEstruture extends StatefulWidget {
  const BuildAppEstruture({super.key});

  @override
  State<BuildAppEstruture> createState() => _BuildAppEstrutureState();
}

class _BuildAppEstrutureState extends State<BuildAppEstruture> {
  int indiceSelecionado = 1;

  void mudarSelecionado(int index) {
    setState(() {
      indiceSelecionado = index;
    });
  }

  final List<Widget> telas = [
    Center(child: Text('Edit')),
    HomeScreen(),
    ConfigScreen(),
  ];

  final GlobalKey _bottomBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDark ? 'assets/img/dark.png' : 'assets/img/light.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // navegação
        bottomNavigationBar: BottomAppBar(
          key: _bottomBarKey,
          color: tema.onPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              abaNavegacao(index: 0, icon: AppIcons.localMarcado, cores: tema),
              abaNavegacao(index: 1, icon: AppIcons.local, cores: tema),
              abaNavegacao(index: 2, icon: AppIcons.config, cores: tema),
            ],
          ),
        ),
        body: telas[indiceSelecionado],
      ),
    );
  }

  Widget abaNavegacao({
    required int index,
    required String icon,
    required ColorScheme cores,
  }) {
    bool selecinado = index == indiceSelecionado;

    return GestureDetector(
      onTap: () => mudarSelecionado(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(10),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selecinado ? Colors.white : Colors.transparent,
        ),

        child: Iconify(
          icon,
          size: 5,
          color: selecinado ? Colors.black : cores.onSurface,
        ),
      ),
    );
  }
}
