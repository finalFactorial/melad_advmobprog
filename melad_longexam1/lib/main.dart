import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Facebook',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: FBColors.background,
            primaryColor: FBColors.primaryBlue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: FBColors.primaryBlue,
              primary: FBColors.primaryBlue,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: FBColors.textSecondary,
              elevation: 0.5,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: FBColors.darkBackground,
            primaryColor: FBColors.primaryBlue,
            colorScheme: const ColorScheme.dark(
              primary: FBColors.primaryBlue,
              surface: FBColors.darkCard,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: FBColors.darkCard,
              foregroundColor: Colors.white,
              elevation: 0.5,
            ),
          ),
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
        );
      },
    );
  }
}

