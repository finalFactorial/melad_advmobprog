import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  /// Fetch comments by post id from DummyJSON
  Future<List<Comment>> getComments(int postId) async {
    try {
      final uri = Uri.parse('$host/comments/post/$postId');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        if (commentsJson.isNotEmpty) {
          return commentsJson.map((c) => Comment.fromJson(c)).toList();
        }
      }
      return _getMockComments(postId);
    } catch (_) {
      return _getMockComments(postId);
    }
  }

  /// Add new comment via DummyJSON POST /comments/add
  Future<Comment?> addComment({
    required int postId,
    required int userId,
    required String body,
    required String userName,
    required String userAvatar,
  }) async {
    try {
      final uri = Uri.parse('$host/comments/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'body': body,
          'postId': postId,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Comment(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch,
          postId: postId,
          userId: userId,
          userName: userName,
          userAvatar: userAvatar,
          body: body,
          likes: 0,
          createdAt: 'Just now',
        );
      }
    } catch (_) {}

    return Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      postId: postId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      body: body,
      likes: 0,
      createdAt: 'Just now',
    );
  }

  List<Comment> _getMockComments(int postId) {
    return [
      Comment(
        id: 1,
        postId: postId,
        userId: 2,
        userName: 'Emily Watson',
        userAvatar: 'https://i.pravatar.cc/300?img=25',
        body: 'Awesome update! Looking forward to testing this out! 🙌',
        likes: 14,
        createdAt: '45m ago',
      ),
      Comment(
        id: 2,
        postId: postId,
        userId: 3,
        userName: 'David Miller',
        userAvatar: 'https://i.pravatar.cc/300?img=15',
        body: 'Great insights! Thanks for sharing this.',
        likes: 8,
        createdAt: '30m ago',
      ),
      Comment(
        id: 3,
        postId: postId,
        userId: 4,
        userName: 'Jessica Taylor',
        userAvatar: 'https://i.pravatar.cc/300?img=32',
        body: 'Can you post more details about the setup guide?',
        likes: 3,
        createdAt: '12m ago',
      ),
    ];
  }
}
