import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reddit_jr/Model/NewsModel.dart';
import 'package:reddit_jr/bloc/news_bloc.dart';
import 'package:reddit_jr/post.dart';

class News extends StatefulWidget {
  News({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final dio = new Dio();
  String last = '';
  bool isLoading = false;
  ScrollController _sc = new ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadApiEvent());
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getNews();
      }
    });
  }

  void _getNews() async {
    context.read<NewsBloc>().add(LoadApiEvent());
  }

  void _toPost(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Post(
              url: 'https://www.reddit.com/r/totalwar/comments/' +
                  id +
                  '/post.json')),
    );
  }

  bool imageCheck(String thumbnail) {
    if(thumbnail == 'self')
      return true;
    else if(thumbnail == 'nsfw')
      return true;
    else if(thumbnail == 'spoiler')
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadedState) {
          List<NewsModel> nList = state.pList;
          return Container(
            color: Colors.grey[900],
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: nList.length,
                controller: _sc,
                itemBuilder: (BuildContext context, int index) {
                  if (index == nList.length)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Opacity(
                          opacity: 1.0,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    );
                  else
                  return new Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: Colors.grey[700],
                    child: Card(
                      color: Colors.grey[900],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _toPost(nList[index].id);
                              },
                              child: Text(
                                nList[index].title,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              child: imageCheck(nList[index].thumbnail)
                                  ? Text('(No Image)',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white54))
                                  : Image(
                                      image:
                                          NetworkImage(nList[index].thumbnail),
                                      fit: BoxFit.fill)),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                              ),
                              Text(nList[index].score.toString(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.comment,
                                color: Colors.white,
                              ),
                              Text(nList[index].num_comments.toString(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        } else {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
