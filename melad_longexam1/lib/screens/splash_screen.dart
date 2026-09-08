import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'home_screen.dart';
import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Artificial splash delay for visual branding & instantiation
    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await _userService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(
                Icons.facebook,
                size: 90,
                color: Color(0xFF1877F2),
              ),
              const Spacer(),
              const Text(
                'from',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.all_inclusive,
                    color: Color(0xFF1877F2),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Meta',
                    style: TextStyle(
                      color: Color(0xFF1877F2),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
