class Comment {
  final int id;
  final int postId;
  final int userId;
  final String userName;
  final String userAvatar;
  final String body;
  int likes;
  final String createdAt;
  bool isLiked;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.body,
    this.likes = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final uId = json['userId'] ?? json['user']?['id'] ?? 1;
    final name = json['user']?['username'] ?? json['userName'] ?? 'User #$uId';
    return Comment(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? json['post_id'] ?? 0,
      userId: uId,
      userName: name,
      userAvatar: json['userAvatar'] ?? 'https://i.pravatar.cc/300?img=${uId % 70}',
      body: json['body'] ?? '',
      likes: json['likes'] ?? (json['id'] != null ? (json['id'] * 2) % 15 : 0),
      createdAt: json['createdAt'] ?? '1h',
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'body': body,
      'likes': likes,
      'createdAt': createdAt,
      'isLiked': isLiked,
    };
  }
}
