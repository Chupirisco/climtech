import 'package:geolocator/geolocator.dart';

Future<bool> checarPermissao() async {
  var permissao = await Geolocator.checkPermission();

  if (permissao == LocationPermission.denied) {
    permissao = await Geolocator.requestPermission();

    if (permissao == LocationPermission.denied) {
      return false;
    }
  }

  if (permissao == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}
