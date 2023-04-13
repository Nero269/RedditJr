import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reddit_jr/Model/NewsModel.dart';
import 'package:reddit_jr/Repositories/NewsRepos.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepos _news = new NewsRepos();
  List<NewsModel> nList = <NewsModel>[];
  String last = '';
  String url;
  NewsBloc(this.url) : super(NewsInitial()) {
    on<LoadApiEvent>((event, emit) async{
      await _news.getNews(url+last);
      nList = _news.news;
      last = _news.last;
      emit(NewsLoadedState(nList, last));
    });
  }
}
