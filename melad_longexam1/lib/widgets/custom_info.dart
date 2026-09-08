import 'package:flutter/material.dart';
import '../constants.dart';

class CustomInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const CustomInfo({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 22, color: FBColors.iconGrey),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: FBFonts.frutiger,
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? FBColors.textPrimary,
                  ),
                  children: [
                    TextSpan(text: '$label '),
                    if (value != null)
                      TextSpan(
                        text: value,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
