import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  Future<List<Post>> getPosts({int limit = 30, int skip = 0}) async {
    try {
      final uri = Uri.parse('$host/posts?limit=$limit&skip=$skip');
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List postsJson = data['posts'] ?? [];
        return postsJson.map((p) => Post.fromJson(p)).toList();
      } else {
        return _getMockPosts();
      }
    } catch (_) {
      // Fallback to offline mock posts if service API is unavailable
      return _getMockPosts();
    }
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    try {
      final uri = Uri.parse('$host/posts/user/$userId');
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List postsJson = data['posts'] ?? [];
        if (postsJson.isNotEmpty) {
          return postsJson.map((p) => Post.fromJson(p)).toList();
        }
      }
      // Fall back to sample mock user posts if endpoint returns empty list or fails
      return _getMockPosts().where((p) => p.userId == userId || userId == 1).toList();
    } catch (_) {
      return _getMockPosts().where((p) => p.userId == userId || userId == 1).toList();
    }
  }

  List<Post> _getMockPosts() {
    return [
      Post(
        id: 1,
        postId: 101,
        userId: 1,
        authorName: 'Mark Zuckerberg',
        authorAvatar: 'https://i.pravatar.cc/300?img=12',
        body: 'Excited to announce our new updates to Meta AI and spatial computing! 🚀 What feature are you most excited for?',
        imageUrl: 'https://picsum.photos/800/500?random=1',
        likes: 3420,
        dislikes: 12,
        commentCount: 450,
        shareCount: 128,
        createdAt: '2 hrs ago',
        updatedAt: '2 hrs ago',
      ),
      Post(
        id: 2,
        postId: 102,
        userId: 2,
        authorName: 'Sarah Jenkins',
        authorAvatar: 'https://i.pravatar.cc/300?img=47',
        body: 'Just finished a gorgeous weekend hike up in the mountains! Fresh air and stunning sunsets 🌄🍃',
        imageUrl: 'https://picsum.photos/800/600?random=2',
        likes: 890,
        dislikes: 2,
        commentCount: 64,
        shareCount: 15,
        createdAt: '4 hrs ago',
        updatedAt: '4 hrs ago',
      ),
      Post(
        id: 3,
        postId: 103,
        userId: 3,
        authorName: 'Tech Insider',
        authorAvatar: 'https://i.pravatar.cc/300?img=60',
        body: 'Flutter 3.x continues to revolutionize cross-platform mobile development with multi-platform desktop and web support.',
        imageUrl: 'https://picsum.photos/800/450?random=3',
        likes: 1540,
        dislikes: 5,
        commentCount: 189,
        shareCount: 92,
        createdAt: '6 hrs ago',
        updatedAt: '6 hrs ago',
      ),
      Post(
        id: 4,
        postId: 104,
        userId: 4,
        authorName: 'Alex Rivera',
        authorAvatar: 'https://i.pravatar.cc/300?img=33',
        body: 'Coffee, code, and continuous learning. Happy coding everyone! ☕💻',
        imageUrl: null,
        likes: 210,
        dislikes: 0,
        commentCount: 18,
        shareCount: 4,
        createdAt: '8 hrs ago',
        updatedAt: '8 hrs ago',
      ),
    ];
  }
}