import 'package:climtech/ui/home/widgets/home_screen.dart';
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
    Center(child: Text('config')),
  ];
  @override
  Widget build(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              abaNavegacao(index: 0),
              abaNavegacao(index: 1),
              abaNavegacao(index: 2),
            ],
          ),
        ),
        body: telas[indiceSelecionado],
      ),
    );
  }

  Widget abaNavegacao({required int index}) {
    return GestureDetector(
      onTap: () => mudarSelecionado(index),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == indiceSelecionado ? Colors.amber : Colors.transparent,
        ),

        child: Icon(Icons.abc),
      ),
    );
  }
}
