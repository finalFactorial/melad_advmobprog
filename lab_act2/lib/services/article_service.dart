import '../constants.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ArticleService {
  List listData = [];

  Future<List> getAllArticle() async {
    Response response = await get(Uri.parse('$host/posts'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      listData = data['posts'];

      return listData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}