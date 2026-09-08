import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';
import 'signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = await _userService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _userService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = _user!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Cover Photo & Avatar Header
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                user.coverUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${user.username}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              user.bio,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Log Out', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomInfo(icon: Icons.work, label: 'Work', value: user.work),
                CustomInfo(icon: Icons.school, label: 'Education', value: user.education),
                CustomInfo(icon: Icons.home, label: 'Lives in', value: user.livesIn),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
