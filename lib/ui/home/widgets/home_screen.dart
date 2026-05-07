import 'package:climtech/ui/home/widgets/modal_calendario.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:climtech/utils/texto_formatado.dart';
import 'package:climtech/utils/descobrir_icone.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
  final itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<SelectLocationViewmodel>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    final homeProvider = Provider.of<HomeViewmodel>(context);

    // scrollar até a hora atual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lista =
          homeProvider.listaHorarioDiaSelecionado.temperaturaModel.hourly;

      if (lista.isNotEmpty) {
        final horaAtual = DateTime.now().hour;

        if (horaAtual < lista.length) {
          itemScrollController.jumpTo(index: horaAtual);
        }
      }
    });

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: margem().right),
      children: [
        cardHome(
          tema,
          Row(
            children: [
              Iconify(
                descobrirIcone(
                  homeProvider.horaAtual ?? 0,
                  homeProvider.probabilidadeChuvaAtual ?? 0,
                ),
                size: 30.sp,
                color: tema.onSurface,
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      formatarLocal(
                        homeProvider.listaHorarioDiaSelecionado.cidade!,
                        homeProvider.listaHorarioDiaSelecionado.siglaEstado!,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: estiloTexto(15),
                    ),
                    Text(
                      homeProvider.temperaturaAgora == null
                          ? 'Carregando'
                          : '${homeProvider.temperaturaAgora}°',
                      style: estiloTexto(22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          width: double.infinity,
          height: 20.h,
          clipBehavior: Clip.hardEdge,
          child: ScrollablePositionedList.builder(
            itemCount: homeProvider
                .listaHorarioDiaSelecionado
                .temperaturaModel
                .hourly
                .length,
            itemScrollController: itemScrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return infoHoraCard(
                climaDia: homeProvider
                    .listaHorarioDiaSelecionado
                    .temperaturaModel
                    .hourly[index],
                tema: tema,
              );
            },
          ),
        ),

        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => ModalCalendario(),
          ),
          child: cardHome(
            tema,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatarDiaTexto(homeProvider.pegarDiaAtual)} de ${formatarMesTexto(homeProvider.pegarDiaAtual)} de ${formatarAnoTexto(homeProvider.pegarDiaAtual)}',
                        style: estiloTexto(18),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatarDiaExtencoTexto(homeProvider.pegarDiaAtual),
                        style: estiloTexto(18),
                      ),
                    ],
                  ),
                ),
                Iconify(
                  AppIcons.calendario,
                  color: tema.onSurface,
                  size: 23.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
