import 'package:climtech/ui/core/build_app_estruture.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Map<String, WidgetBuilder> rotas() {
    return {'/': (context) => BuildAppEstruture()};
  }
}
