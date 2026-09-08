import 'package:flutter/material.dart';
import '../constants.dart';

class CustomFont extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  const CustomFont({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = FBFonts.frutiger,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.maxLines,
  });

  factory CustomFont.logo({
    required String text,
    double fontSize = 28,
    Color color = FBColors.primaryBlue,
  }) {
    return CustomFont(
      text: text,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: FBFonts.klavika,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}
