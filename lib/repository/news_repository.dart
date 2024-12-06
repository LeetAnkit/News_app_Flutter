import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/Models/categoreis_news_model.dart';
import 'package:news_app/Models/news_channel_headlines_models.dart';

//API INTEGRATION is done here
class NewsRepository {

  Future<NewsChannelHeadLinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=08faa8c604e845049c3d4d2def20f859';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadLinesModel.fromJson(body);
    }

    throw Exception('Error fetching news headlines');
  }

  Future<CategoriesNewsModel> findCategoriesNewsApi(String category) async {
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=08faa8c604e845049c3d4d2def20f859';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }

    throw Exception('Error fetching category news');
  }
}
