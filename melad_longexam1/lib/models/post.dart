class Post {
  final int id;
  final int postId;
  final int userId;
  final String body;
  int likes;
  final int dislikes;
  final String createdAt;
  final String updatedAt;
  
  // UI extended attributes
  final String authorName;
  final String authorAvatar;
  final String? imageUrl;
  int commentCount;
  final int shareCount;
  bool isLiked;

  Post({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
    this.authorName = 'User',
    this.authorAvatar = 'https://i.pravatar.cc/300?img=1',
    this.imageUrl,
    this.commentCount = 12,
    this.shareCount = 3,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? 0;
    final pId = json['postId'] ?? json['post_id'] ?? rawId;
    final uId = json['userId'] ?? json['user_id'] ?? 1;
    
    // Parse likes and dislikes
    int rawLikes = 0;
    int rawDislikes = 0;
    if (json['reactions'] != null && json['reactions'] is Map) {
      rawLikes = (json['reactions']['likes'] as num?)?.toInt() ?? 0;
      rawDislikes = (json['reactions']['dislikes'] as num?)?.toInt() ?? 0;
    } else {
      rawLikes = (json['likes'] as num?)?.toInt() ?? (15 + (rawId * 7) % 250).toInt();
      rawDislikes = (json['dislikes'] as num?)?.toInt() ?? 0;
    }

    // Determine author & media details
    final author = json['authorName'] ?? json['user']?['name'] ?? 'User #$uId';
    final avatar = json['authorAvatar'] ?? json['user']?['avatarUrl'] ?? 'https://i.pravatar.cc/300?img=${uId % 70}';
    final media = json['imageUrl'] ?? (rawId % 2 == 0 ? 'https://picsum.photos/800/600?random=$rawId' : null);

    return Post(
      id: rawId,
      postId: pId,
      userId: uId,
      body: json['body'] ?? json['title'] ?? '',
      likes: rawLikes,
      dislikes: rawDislikes,
      createdAt: json['createdAt'] ?? json['created_at'] ?? '2 hrs ago',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '2 hrs ago',
      authorName: author,
      authorAvatar: avatar,
      imageUrl: media,
      commentCount: json['commentCount'] ?? (5 + (rawId * 3) % 40),
      shareCount: json['shareCount'] ?? (1 + rawId % 15),
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'body': body,
      'reactions': {
        'likes': likes,
        'dislikes': dislikes,
      },
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'imageUrl': imageUrl,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
    };
  }
}