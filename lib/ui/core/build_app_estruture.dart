import 'package:climtech/ui/confg/widgets/config_screen.dart';
import 'package:climtech/ui/home/widgets/home_screen.dart';
import 'package:climtech/ui/select_location/view_models/locations_saves_viewmodel.dart';
import 'package:climtech/ui/select_location/widgets/select_location_screen.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';

import '../home/view_models/home_viewmodel.dart';
import '../select_location/view_models/select_location_viewmodel.dart';

class BuildAppEstruture extends StatefulWidget {
  final int initialIndex;
  final bool iniciarProviders;

  const BuildAppEstruture({
    super.key,
    this.initialIndex = 1,
    this.iniciarProviders = true,
  });

  @override
  State<BuildAppEstruture> createState() => _BuildAppEstrutureState();
}

class _BuildAppEstrutureState extends State<BuildAppEstruture> {
  late int indiceSelecionado;

  @override
  void initState() {
    super.initState();

    indiceSelecionado = widget.initialIndex;

    Future.microtask(() {
      if (!mounted) return;

      if (widget.iniciarProviders) {
        context.read<HomeViewmodel>().carregarDadosLocalAtual(DateTime.now());
        context.read<LocationsSavesViewmodel>().carregarLocaisSalvos();
      } else {
        final prov = context.read<SelectLocationViewmodel>();
        context.read<HomeViewmodel>().muldarLocal(
          prov.selectedCity!,
          prov.nomeEstadoSelecionado!,
        );
      }
    });
  }

  void mudarSelecionado(int index) {
    setState(() {
      indiceSelecionado = index;
    });
  }

  final List<Widget> telas = [
    SelectLocationScreen(),
    HomeScreen(),
    ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewmodel>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/img/dark.png'
                : 'assets/img/light.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: viewModel.isLoading
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: CircularProgressIndicator()),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: BottomAppBar(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    abaNavegacao(
                      index: 0,
                      icon: AppIcons.localMarcado,
                      cores: Theme.of(context).colorScheme,
                    ),
                    abaNavegacao(
                      index: 1,
                      icon: AppIcons.local,
                      cores: Theme.of(context).colorScheme,
                    ),
                    abaNavegacao(
                      index: 2,
                      icon: AppIcons.config,
                      cores: Theme.of(context).colorScheme,
                    ),
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
