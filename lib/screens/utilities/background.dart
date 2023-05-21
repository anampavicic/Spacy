import 'package:flutter/material.dart';

class GradientBoxDecoration {
  static const BoxDecoration gradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0F2027),
        Color(0xFF203A43),
        Color(0xFF2C5364),
      ],
    ),
  );
}
