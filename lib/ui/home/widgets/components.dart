import 'package:flutter/material.dart';

Widget homeCard(ColorScheme tema, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: tema.onSecondary,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
    width: double.infinity,
    child: child,
  );
}
