import 'package:climtech/data/repositories/local/consultar_local.dart';
import 'package:climtech/ui/home/view_models/home_viewmodel.dart';
import 'package:climtech/ui/home/widgets/components.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/estilos_pradroes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    final homeProvider = Provider.of<HomeViewmodel>(context);

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: margem().right),
      children: [
        homeCard(
          tema,
          Row(
            children: [
              Iconify(AppIcons.sol, size: 30.sp),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      homeProvider.listaHorarioDiaSelecionado.nome ?? 'ERROR',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: estiloTexto(15),
                    ),
                    Text(
                      '${homeProvider.pegarTemperaturaAtual}°',
                      style: estiloTexto(22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
