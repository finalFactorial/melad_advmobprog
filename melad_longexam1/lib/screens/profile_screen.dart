import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();

  User? _user;
  List<Post> _userPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final user = await _userService.getCurrentUser();
    final rawPosts = await _postService.getPostsByUserId(user.id);
    final posts = rawPosts
        .map((p) => p.copyWithUser(name: user.name, avatarUrl: user.avatarUrl))
        .toList();

    if (mounted) {
      setState(() {
        _user = user;
        _userPosts = posts;
        _isLoading = false;
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Center(
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action Buttons: Edit Profile & Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add to story', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _openSettings,
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                ),
              ],
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
                if (user.work.isNotEmpty) CustomInfo(icon: Icons.work, label: 'Work', value: user.work),
                if (user.companyDepartment.isNotEmpty) CustomInfo(icon: Icons.business, label: 'Department', value: user.companyDepartment),
                if (user.education.isNotEmpty) CustomInfo(icon: Icons.school, label: 'Education', value: user.education),
                if (user.livesIn.isNotEmpty) CustomInfo(icon: Icons.home, label: 'Lives in', value: user.livesIn),
                if (user.email.isNotEmpty) CustomInfo(icon: Icons.email, label: 'Email', value: user.email),
                if (user.phone.isNotEmpty) CustomInfo(icon: Icons.phone, label: 'Phone', value: user.phone),
                if (user.gender.isNotEmpty) CustomInfo(icon: Icons.person_outline, label: 'Gender', value: '${user.gender} (${user.age} yrs)'),
                CustomInfo(icon: Icons.people, label: 'Followed by', value: '${user.followerCount} people'),
              ],
            ),
          ),
          const Divider(thickness: 8, color: Color(0xFFF0F2F5)),
          // User Posts Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Posts",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                Text(
                  '${_userPosts.length} posts',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (_userPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(
                child: Text(
                  'No posts yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _userPosts.length,
              itemBuilder: (context, index) {
                return PostCard(post: _userPosts[index]);
              },
            ),
        ],
      ),
    );
  }
}
