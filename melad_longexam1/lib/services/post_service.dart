import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/post.dart';

class PostService {
  static const String keyPostLikes = 'persisted_post_likes';
  static const String keyPostIsLiked = 'persisted_post_is_liked';

  /// Save post like state to SharedPreferences
  Future<void> savePostLike(int postId, int likes, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    final likesMapJson = prefs.getString(keyPostLikes) ?? '{}';
    final isLikedMapJson = prefs.getString(keyPostIsLiked) ?? '{}';

    final Map<String, dynamic> likesMap = jsonDecode(likesMapJson);
    final Map<String, dynamic> isLikedMap = jsonDecode(isLikedMapJson);

    likesMap[postId.toString()] = likes;
    isLikedMap[postId.toString()] = isLiked;

    await prefs.setString(keyPostLikes, jsonEncode(likesMap));
    await prefs.setString(keyPostIsLiked, jsonEncode(isLikedMap));
  }

  /// Apply persisted likes to post list
  Future<void> _applyPersistedPostLikes(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final likesMapJson = prefs.getString(keyPostLikes) ?? '{}';
    final isLikedMapJson = prefs.getString(keyPostIsLiked) ?? '{}';

    final Map<String, dynamic> likesMap = jsonDecode(likesMapJson);
    final Map<String, dynamic> isLikedMap = jsonDecode(isLikedMapJson);

    for (final post in posts) {
      final key = post.id.toString();
      if (likesMap.containsKey(key)) {
        post.likes = (likesMap[key] as num).toInt();
      }
      if (isLikedMap.containsKey(key)) {
        post.isLiked = isLikedMap[key] as bool;
      }
    }
  }

  Future<List<Post>> getPosts({int limit = 30, int skip = 0}) async {
    List<Post> posts = [];
    try {
      final uri = Uri.parse('$host/posts?limit=$limit&skip=$skip');
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List postsJson = data['posts'] ?? [];
        posts = postsJson.map((p) => Post.fromJson(p)).toList();
      } else {
        posts = _getMockPosts();
      }
    } catch (_) {
      posts = _getMockPosts();
    }
    await _applyPersistedPostLikes(posts);
    return posts;
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    List<Post> posts = [];
    try {
      final uri = Uri.parse('$host/posts/user/$userId');
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'}).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List postsJson = data['posts'] ?? [];
        if (postsJson.isNotEmpty) {
          posts = postsJson.map((p) => Post.fromJson(p)).toList();
        }
      }
    } catch (_) {}

    if (posts.isEmpty) {
      final mockMatches = _getMockPosts().where((p) => p.userId == userId).toList();
      if (mockMatches.isNotEmpty) {
        posts = mockMatches;
      } else {
        posts = [
          Post(
            id: 1000 + userId,
            postId: 1000 + userId,
            userId: userId,
            authorName: 'Logged In User',
            authorAvatar: 'https://i.pravatar.cc/300?img=${userId % 70}',
            body: 'Welcome to my profile! Excited to share my thoughts and updates here. 🚀✨',
            imageUrl: 'https://picsum.photos/800/500?random=$userId',
            likes: 124,
            dislikes: 1,
            commentCount: 18,
            shareCount: 5,
            createdAt: '1 day ago',
            updatedAt: '1 day ago',
          ),
        ];
      }
    }
    await _applyPersistedPostLikes(posts);
    return posts;
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