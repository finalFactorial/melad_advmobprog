import 'package:flutter/material.dart';
import '../constants.dart';
import 'custom_font.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final bool isExpanded;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = FBColors.primaryBlue,
    this.textColor = Colors.white,
    this.icon,
    this.height = 42,
    this.borderRadius = 8,
    this.isExpanded = true,
  });

  factory CustomButton.secondary({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: FBColors.buttonGrey,
      textColor: FBColors.textPrimary,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
        ],
        CustomFont(
          text: text,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: isExpanded ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
