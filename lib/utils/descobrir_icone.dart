import 'package:climtech/utils/icons.dart';

String descobrirIcone(int hora, int probabilidadeDeChuva) {
  //icones da lua
  if (hora >= 18 || hora <= 6) {
    if (probabilidadeDeChuva <= 20) {
      // lua
      return AppIcons.lua;
    } else if (probabilidadeDeChuva <= 40) {
      //nublado
      return AppIcons.luaNublado;
    } else if (probabilidadeDeChuva <= 70) {
      //chuva
      return AppIcons.luaChuva;
    } else {
      // chuva forte
      return AppIcons.chuvaForte;
    }
  }
  //icones do sol
  else {
    if (probabilidadeDeChuva <= 20) {
      // sol
      return AppIcons.sol;
    } else if (probabilidadeDeChuva <= 40) {
      //nublado
      return AppIcons.solNublado;
    } else if (probabilidadeDeChuva <= 70) {
      //chuva
      return AppIcons.solChuva;
    } else {
      // chuva forte
      return AppIcons.chuvaForte;
    }
  }
}
