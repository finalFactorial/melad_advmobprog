import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> getComments(int postId) async {
    try {
      final uri = Uri.parse('$host/comments/post/$postId');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        return commentsJson.map((c) => Comment.fromJson(c)).toList();
      } else {
        return _getMockComments(postId);
      }
    } catch (_) {
      return _getMockComments(postId);
    }
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
