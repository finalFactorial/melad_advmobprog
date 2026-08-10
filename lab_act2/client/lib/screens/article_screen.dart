import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/article_model.dart';
import '../services/article_service.dart';
import '../widgets/custom_text.dart';
import 'article_detail_screen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late Future<List<Article>> _futureArticles;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _likedArticleIds = <int>{};
  final Map<int, int> _commentCounts = <int, int>{};

  @override
  void initState() {
    super.initState();
    _futureArticles = _getAllArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Article>> _getAllArticles() async {
    final response = await ArticleService().getAllArticle();
    // Map raw list to typed models once
    return (response).map((e) => Article.fromJson(e)).toList();
  }

  void _toggleLike(int articleId) {
    setState(() {
      if (_likedArticleIds.contains(articleId)) {
        _likedArticleIds.remove(articleId);
      } else {
        _likedArticleIds.add(articleId);
      }
    });
  }

  void _addComment() {}

  String _getInitials(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) {
      return 'A';
    }

    final initials = words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  String _getDisplayName(String text, int articleId) {
    final names = <String>[
      'Mina Green',
      'Alya Snow',
      'Kai Ryn',
      'Nara Moon',
      'Zoe Vale',
      'Jules Ply',
      'Luna Ken',
      'Rin Sky',
      'Mika Fox',
      'Sora Lee',
    ];

    if (text.trim().isEmpty) {
      return names[articleId % names.length];
    }

    final index = (articleId + text.length) % names.length;
    return names[index];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.primary,
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search articles',
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          // List
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _futureArticles,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        text: 'No articles to display.',
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator.adaptive(strokeWidth: 3.sp),
                        SizedBox(height: 10.h),
                        CustomText(
                          text: 'Loading articles...',
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                  );
                }

                final articles = snapshot.data ?? [];
                final filteredArticles = articles.where((article) {
                  final query = _searchQuery.toLowerCase();
                  final title = article.title.toLowerCase();
                  final body = article.body.toLowerCase();
                  return title.contains(query) || body.contains(query);
                }).toList();

                if (filteredArticles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        text: _searchQuery.isEmpty
                            ? 'No articles to display.'
                            : 'No articles match your search.',
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  itemCount: filteredArticles.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final article = filteredArticles[index];
                    final isLiked = _likedArticleIds.contains(article.id);
                    final commentCount =
                        _commentCounts[article.id] ?? (article.id % 5 + 2);
                    final avatarName = _getDisplayName(
                      article.title,
                      article.id,
                    );
                    final avatarColor = Color(
                      (article.id * 0x1F2A3B + 0xFF000000) % 0xFFFFFFFF,
                    ).withOpacity(1);

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: avatarColor,
                                    child: Text(
                                      _getInitials(avatarName),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: _getDisplayName(
                                            article.title,
                                            article.id,
                                          ),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      'https://picsum.photos/seed/${article.id}/200',
                                      height: 90.h,
                                      width: 90.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.broken_image),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: article.title,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6.h),
                                        CustomText(
                                          text: article.body,
                                          fontSize: 13.sp,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _toggleLike(article.id),
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 18.sp,
                                      color: isLiked ? Colors.redAccent : null,
                                    ),
                                    label: Text('${isLiked ? 1 : 0}'),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  TextButton.icon(
                                    onPressed: _addComment,
                                    icon: Icon(
                                      Icons.mode_comment_outlined,
                                      size: 18.sp,
                                    ),
                                    label: Text('$commentCount'),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
