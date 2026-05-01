import 'package:intl/intl.dart';

String formatarDiaTexto(DateTime data) {
  return DateFormat('dd').format(data);
}

String formatarMesTexto(DateTime data) {
  final mes = DateFormat('MMMM', 'pt_BR').format(data);

  return mes[0].toUpperCase() + mes.substring(1);
}

String formatarAnoTexto(DateTime data) {
  return DateFormat('yyyy').format(data);
}

String formatarDiaExtencoTexto(DateTime data) {
  final dia = DateFormat('EEEE', 'pt_BR').format(data);
  return dia[0].toUpperCase() + dia.substring(1);
}

String formatarLocal(String cidade, String ul) {
  return '$cidade - $ul';
}
