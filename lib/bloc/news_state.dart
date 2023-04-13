part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoadedState extends NewsState{
  final List<NewsModel> pList;
  final String last;



  NewsLoadedState(this.pList, this.last);

  @override
  List<Object> get props => [this.pList, this.last];
}

