part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {
  const NewsEvent();
}

class LoadApiEvent extends NewsEvent{
  @override
  List<Object> get props => [];
}
