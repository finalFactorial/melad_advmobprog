import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/post.dart';
import '../screens/detail_screen.dart';
import '../services/post_service.dart';
import 'custom_font.dart';
import 'custom_inkwell_button.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      widget.post.isLiked = _isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
      widget.post.likes = _likeCount;
    });
    PostService().savePostLike(widget.post.id, _likeCount, _isLiked);
  }

  void _openDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(post: widget.post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User Info & Menu
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(widget.post.authorAvatar),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.post.authorName,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      Row(
                        children: [
                          CustomFont(
                            text: widget.post.createdAt,
                            fontSize: 12,
                            color: FBColors.textSecondary,
                          ),
                          const CustomFont(text: ' • ', fontSize: 12, color: FBColors.textSecondary),
                          const Icon(Icons.public, size: 12, color: FBColors.textSecondary),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: FBColors.iconGrey),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Body Text
          if (widget.post.body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: CustomFont(
                text: widget.post.body,
                fontSize: 14,
              ),
            ),

          const SizedBox(height: 8),

          // Post Image/Media if present
          if (widget.post.imageUrl != null)
            GestureDetector(
              onTap: _openDetailScreen,
              child: CachedNetworkImage(
                imageUrl: widget.post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 240,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),

          // Reaction Counts & Comments Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: FBColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.thumb_up, size: 10, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    CustomFont(
                      text: '$_likeCount',
                      fontSize: 13,
                      color: FBColors.textSecondary,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _openDetailScreen,
                  child: CustomFont(
                    text: '${widget.post.commentCount} comments',
                    fontSize: 13,
                    color: FBColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, indent: 12, endIndent: 12),

          // Action Buttons: Like, Comment, Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Row(
              children: [
                CustomInkwellButton(
                  icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  label: 'Like',
                  isSelected: _isLiked,
                  onTap: _toggleLike,
                ),
                CustomInkwellButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Comment',
                  onTap: _openDetailScreen,
                ),
                CustomInkwellButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post shared to your timeline!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
