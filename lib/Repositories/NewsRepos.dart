import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:reddit_jr/Model/DataModel.dart';
import 'package:reddit_jr/Model/NewsModel.dart';
import 'package:reddit_jr/news.dart';

class NewsRepos {
  String url = '';
  String last = '';
  List<NewsModel> news = <NewsModel> [];
  Future<void> getNews(String url) async {
    final dio = new Dio();
    final response = await dio.get(url);
    News _news = new News();
    var data = DataModel.fromMap(response.data['data']);
    for(var item in data.children){
      news.add(item.data);
    }
    last = news[news.length-1].name;
  }
}
