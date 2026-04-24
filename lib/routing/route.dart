import 'package:climtech/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Map<String, WidgetBuilder> rotas() {
    return {'/': (context) => HomeScreen()};
  }
}
