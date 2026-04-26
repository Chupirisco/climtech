import 'package:climtech/ui/confg/view_models/tema_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:provider/provider.dart';

Widget configCard({required Widget child, required Color backgroundColor}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
    width: double.infinity,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}

AnimatedToggleSwitch alternarTema(BuildContext ctx) {
  final themeController = Provider.of<ThemeController>(ctx);

  return AnimatedToggleSwitch<bool>.dual(
    current: themeController.isDark(ctx),
    first: false,
    second: true,
    onChanged: (value) => themeController.setTheme(value),
  );
}
