import 'package:climtech/ui/select_location/view_models/locations_saves_viewmodel.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:climtech/utils/descobrir_icone.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/models/locais_salvos_model.dart';

Widget cardSalvos(ColorScheme tema, LocaisSalvos prov) {
  return Container(
    margin: EdgeInsets.only(top: 1.h),
    decoration: BoxDecoration(
      color: tema.onPrimary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: Iconify(AppIcons.pin, size: 20.sp),
      title: Text('${prov.cidade} - ${prov.estado}', style: estiloTexto(15)),
      subtitle: Text('${prov.temperaturaAtual}°', style: estiloTexto(13)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            descobrirIcone(DateTime.now().hour, prov.climaAtual),
            size: 20.sp,
          ),
          Text('${prov.climaAtual}%', style: estiloTexto(15)),
        ],
      ),
    ),
  );
}

Widget cardResultados(
  ColorScheme tema,
  String cidade,
  SelectLocationViewmodel slProv,
  LocationsSavesViewmodel scProv,
) {
  return Container(
    margin: EdgeInsets.only(top: 1.h),
    decoration: BoxDecoration(
      color: tema.onPrimary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: Iconify(AppIcons.local, size: 20.sp),
      title: Text(cidade, style: estiloTexto(15)),
      trailing: IconButton(
        icon: Iconify(AppIcons.pin, size: 20.sp),
        onPressed: () =>
            scProv.adicionarLocal(cidade, slProv.selectedState!.name),
      ),
      onTap: () => slProv.selectCity(cidade),
    ),
  );
}
