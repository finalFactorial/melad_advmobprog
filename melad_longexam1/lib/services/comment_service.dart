import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  static const String keyCustomComments = 'persisted_custom_comments';
  static const String keyCommentLikes = 'persisted_comment_likes';
  static const String keyCommentIsLiked = 'persisted_comment_is_liked';

  /// Save comment like state to SharedPreferences
  Future<void> saveCommentLike(int commentId, int likes, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    final likesMapJson = prefs.getString(keyCommentLikes) ?? '{}';
    final isLikedMapJson = prefs.getString(keyCommentIsLiked) ?? '{}';

    final Map<String, dynamic> likesMap = jsonDecode(likesMapJson);
    final Map<String, dynamic> isLikedMap = jsonDecode(isLikedMapJson);

    likesMap[commentId.toString()] = likes;
    isLikedMap[commentId.toString()] = isLiked;

    await prefs.setString(keyCommentLikes, jsonEncode(likesMap));
    await prefs.setString(keyCommentIsLiked, jsonEncode(isLikedMap));
  }

  /// Fetch comments by post id from DummyJSON and append locally saved comments
  Future<List<Comment>> getComments(int postId) async {
    List<Comment> list = [];
    try {
      final uri = Uri.parse('$host/comments/post/$postId');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        if (commentsJson.isNotEmpty) {
          list = commentsJson.map((c) => Comment.fromJson(c)).toList();
        }
      }
    } catch (_) {}

    if (list.isEmpty) {
      list = _getMockComments(postId);
    }

    // Load user added custom comments from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final customJsonStr = prefs.getString(keyCustomComments) ?? '[]';
    final List customJsonList = jsonDecode(customJsonStr);
    for (final item in customJsonList) {
      final c = Comment.fromJson(item);
      if (c.postId == postId) {
        list.add(c);
      }
    }

    // Apply persisted likes to comments
    final likesMapJson = prefs.getString(keyCommentLikes) ?? '{}';
    final isLikedMapJson = prefs.getString(keyCommentIsLiked) ?? '{}';
    final Map<String, dynamic> likesMap = jsonDecode(likesMapJson);
    final Map<String, dynamic> isLikedMap = jsonDecode(isLikedMapJson);

    for (final comment in list) {
      final key = comment.id.toString();
      if (likesMap.containsKey(key)) {
        comment.likes = (likesMap[key] as num).toInt();
      }
      if (isLikedMap.containsKey(key)) {
        comment.isLiked = isLikedMap[key] as bool;
      }
    }

    return list;
  }

  /// Add new comment via DummyJSON POST /comments/add and persist to SharedPreferences
  Future<Comment?> addComment({
    required int postId,
    required int userId,
    required String body,
    required String userName,
    required String userAvatar,
  }) async {
    Comment newComment;
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
        newComment = Comment(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch,
          postId: postId,
          userId: userId,
          userName: userName,
          userAvatar: userAvatar,
          body: body,
          likes: 0,
          createdAt: 'Just now',
        );
      } else {
        newComment = Comment(
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
    } catch (_) {
      newComment = Comment(
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

    // Persist newly created comment to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final customJsonStr = prefs.getString(keyCustomComments) ?? '[]';
    final List customJsonList = jsonDecode(customJsonStr);
    customJsonList.add(newComment.toJson());
    await prefs.setString(keyCustomComments, jsonEncode(customJsonList));

    return newComment;
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
