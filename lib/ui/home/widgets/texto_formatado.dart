import 'package:intl/intl.dart';

String formatarDiaTexto(DateTime data) {
  return DateFormat('dd').format(data);
}

String formatarMesTexto(DateTime data) {
  return DateFormat('MMMM', 'pt_BR').format(data);
}

String formatarAnoTexto(DateTime data) {
  return DateFormat('yyyy').format(data);
}

String formatarDiaExtencoTexto(DateTime data) {
  final dia = DateFormat('EEEE', 'pt_BR').format(data);
  return dia[0].toUpperCase() + dia.substring(1);
}
