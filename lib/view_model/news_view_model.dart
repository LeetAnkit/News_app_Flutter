import 'package:news_app/Models/categoreis_news_model.dart';
import 'package:news_app/Models/news_channel_headlines_models.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {

  final _rep = NewsRepository();  // calling the function class

  Future<NewsChannelHeadLinesModel> fetchNewsChannelHeadlinesApi({required String channelName}) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi({required String category}) async {
    final response = await _rep.findCategoriesNewsApi(category);
    return response;
  }
}
