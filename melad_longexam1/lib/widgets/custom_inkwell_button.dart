import 'package:flutter/material.dart';
import 'custom_font.dart';

class CustomInkwellButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool isSelected;

  const CustomInkwellButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isSelected ? Colors.blue : (iconColor ?? Colors.grey[600]);
    final effectiveTextColor = isSelected ? Colors.blue : (textColor ?? Colors.grey[700]);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: effectiveColor),
                const SizedBox(width: 6),
                CustomFont(
                  text: label,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: effectiveTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
