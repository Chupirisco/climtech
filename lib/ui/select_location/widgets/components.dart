import 'package:climtech/ui/select_location/view_models/locations_saves_viewmodel.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:climtech/utils/descobrir_icone.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/models/locais_salvos_model.dart';
import '../../core/build_app_estruture.dart';

Widget cardSalvos(
  ColorScheme tema,
  LocaisSalvos local,
  LocationsSavesViewmodel prov,
  int index,
  SelectLocationViewmodel slProv,
  BuildContext ctx,
) {
  return Container(
    margin: EdgeInsets.only(top: 1.h),
    decoration: BoxDecoration(
      color: tema.onPrimary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: IconButton(
        icon: Iconify(AppIcons.pin, size: 20.sp, color: tema.onSurface),
        onPressed: () => prov.removerLocal(index),
      ),
      title: Text('${local.cidade} - ${local.estado}', style: estiloTexto(15)),
      subtitle: Text('${local.temperaturaAtual}°', style: estiloTexto(13)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            descobrirIcone(DateTime.now().hour, local.probabilidadeDeChuva),
            size: 20.sp,
            color: tema.onSurface,
          ),
          Text('${local.probabilidadeDeChuva}%', style: estiloTexto(15)),
        ],
      ),
      onTap: () {
        slProv.selectCity(local.cidade, local.estado);
        Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                BuildAppEstruture(initialIndex: 1, iniciarProviders: false),
          ),
          (route) => false,
        );
      },
    ),
  );
}

Widget cardResultados(
  ColorScheme tema,
  String cidade,
  SelectLocationViewmodel slProv,
  LocationsSavesViewmodel scProv,
  BuildContext ctx,
) {
  return Container(
    margin: EdgeInsets.only(top: 1.h),
    decoration: BoxDecoration(
      color: tema.onPrimary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: Iconify(AppIcons.local, size: 20.sp, color: tema.onSurface),
      title: Text(cidade, style: estiloTexto(15)),
      trailing: IconButton(
        icon: Iconify(AppIcons.pin, size: 20.sp, color: tema.onSurface),
        onPressed: () => scProv.adicionarLocal(
          cidade,
          slProv.selectedState!.name,
          slProv.selectedState!.code,
        ),
      ),
      onTap: () {
        slProv.selectCity(cidade, slProv.selectedState!.name);
        Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                BuildAppEstruture(initialIndex: 1, iniciarProviders: false),
          ),
          (route) => false,
        );
        slProv.reset();
      },
    ),
  );
}
