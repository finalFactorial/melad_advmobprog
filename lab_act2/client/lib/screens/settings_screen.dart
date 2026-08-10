import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Appearance',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 12.h),
              Card(
                child: ListTile(
                  title: const Text('Dark mode'),
                  trailing: Switch(
                    value: themeModel.isDark,
                    onChanged: (_) => themeModel.toggleTheme(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
