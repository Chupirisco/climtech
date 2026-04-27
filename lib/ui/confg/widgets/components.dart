import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';

import '../view_models/tema_viewmodel.dart';

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
  final tema = Theme.of(ctx).colorScheme;

  return AnimatedToggleSwitch<bool>.dual(
    padding: EdgeInsets.all(5),
    current: themeController.isDark(ctx),
    height: 65,
    indicatorSize: Size(60, 60),
    first: false,
    second: true,
    styleBuilder: (value) => ToggleStyle(
      borderColor: Colors.transparent,
      backgroundColor: tema.onSecondary,
      indicatorColor: tema.onSurface,
    ),
    iconBuilder: (value) => Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: tema.onSurface),
      child: Iconify(
        value ? AppIcons.lua : AppIcons.sol,
        color: value ? Colors.black : Colors.white,
      ),
    ),
    onChanged: (value) => themeController.setTheme(value ? 'dark' : 'light'),
  );
}
