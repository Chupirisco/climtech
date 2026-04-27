import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

TextStyle estiloTexto(double tamanho, {Color? cor, FontWeight? peso}) {
  return TextStyle(fontSize: tamanho.sp, color: cor, fontWeight: peso);
}

EdgeInsets margem() {
  return EdgeInsets.symmetric(horizontal: 100.h * 0.03);
}
