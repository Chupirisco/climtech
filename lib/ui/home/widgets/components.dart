import 'package:climtech/domain/models/temperatura_model.dart';
import 'package:climtech/utils/descobrir_icone.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

Widget cardHome(ColorScheme tema, Widget child) {
  return Container(
    margin: EdgeInsets.only(top: 75),
    decoration: BoxDecoration(
      color: tema.onSecondary,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
    width: double.infinity,
    child: child,
  );
}

Widget infoHoraCard({
  required ColorScheme tema,
  required TemperaturaEClima climaDia,
}) {
  final hora = DateFormat('HH').format(climaDia.data);

  String horaFormatada() {
    final hoje = DateTime.now();

    if (int.parse(hora) == hoje.hour && climaDia.data.day == hoje.day) {
      return 'Agora';
    } else {
      return int.parse(hora) <= 12 ? '$hora AM' : '$hora PM';
    }
  }

  final icone = descobrirIcone(int.parse(hora), climaDia.probabilidadeDeChuva);

  return Container(
    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    decoration: BoxDecoration(
      color: tema.onSecondary,
      borderRadius: BorderRadius.circular(20),
    ),
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(horaFormatada(), style: estiloTexto(15)),
        Iconify(icone, color: tema.onSurface, size: 27.sp),

        Text(
          '${climaDia.probabilidadeDeChuva.toString()}%',
          style: estiloTexto(14),
        ),
        Text('${climaDia.temperatura.toString()}°', style: estiloTexto(20)),
      ],
    ),
  );
}
