import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../widgets/post_card.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
  final TextEditingController _commentController = TextEditingController();

  User? _currentUser;
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final user = await _userService.getCurrentUser();
    final comments = await _commentService.getComments(widget.post.id);
    if (mounted) {
      setState(() {
        _currentUser = user;
        _comments = comments;
        _isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final user = _currentUser;
    final createdComment = await _commentService.addComment(
      postId: widget.post.id,
      userId: user?.id ?? 1,
      body: text,
      userName: user?.name ?? 'Authenticated User',
      userAvatar: user?.avatarUrl ?? 'https://i.pravatar.cc/300?img=12',
    );

    if (mounted) {
      setState(() {
        if (createdComment != null) {
          _comments.add(createdComment);
          widget.post.commentCount += 1;
        }
        _commentController.clear();
        _isSubmitting = false;
      });
    }
  }

  void _toggleCommentLike(Comment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      if (comment.isLiked) {
        comment.likes += 1;
      } else {
        comment.likes -= 1;
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(post: widget.post),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Comments (${_comments.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  else if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No comments yet. Be the first to comment!'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment.userAvatar),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.userName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                comment.createdAt,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(comment.body),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => _toggleCommentLike(comment),
                                    child: Row(
                                      children: [
                                        Icon(
                                          comment.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                          size: 16,
                                          color: comment.isLiked ? const Color(0xFF1877F2) : Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Like',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: comment.isLiked ? FontWeight.bold : FontWeight.normal,
                                            color: comment.isLiked ? const Color(0xFF1877F2) : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (comment.likes > 0) ...[
                                    const SizedBox(width: 12),
                                    Text(
                                      '${comment.likes} ${comment.likes == 1 ? 'like' : 'likes'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send, color: Color(0xFF1877F2)),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
