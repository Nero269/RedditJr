import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_jr/Bookmarked.dart';
import 'package:reddit_jr/Repositories/NewsRepos.dart';
import 'package:reddit_jr/bloc/news_bloc.dart';

import 'package:reddit_jr/news.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Jr.',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => NewsRepos(),
        child: MyHomePage(title: 'TOTAL WAR SUBREDDIT'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final dio = new Dio();

  var pages = [
    BlocProvider(
      create: (_) =>
          NewsBloc(
              'https://www.reddit.com/r/totalwar/new.json?sort=new&limit=25&after='),
      child: News(),
    ),
    BlocProvider(
      create: (_) =>
          NewsBloc(
              'https://www.reddit.com/r/totalwar/hot.json?sort=hot&limit=25&after='),
      child: News(),
    ),
    BlocProvider(
      create: (_) =>
          NewsBloc(
              'https://www.reddit.com/r/totalwar/top.json?sort=top&limit=25&after='),
      child: News(),
    ),
    BlocProvider(
      create: (_) =>
          NewsBloc(
              'https://www.reddit.com/r/totalwar/rising.json?sort=rising&limit=25&after='),
      child: News(),
    ),
    Bookmarked()
  ];
  var _appPageController = PageController();

  setBottomBarIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
    _appPageController.jumpToPage(index);
  }

  bool isLoading = false;

  @override
  void initState() {
    _initBody();
    super.initState();
  }

  void _initBody() {
    setState(() {

    });
  }

  void onTapHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title, textAlign: TextAlign.center),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              }
          )
        ],
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: new Theme(data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          primaryColor: Colors.red,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
              backgroundColor: Colors.red[900],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.wb_sunny_outlined),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department),
                  label: 'Hot',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  label: 'Top',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart),
                  label: 'Rising',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark),
                  label: 'Bookmarked',
                ),

              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[500],
              onTap: (int index) {
                setBottomBarIndex(index);
              })
      ),

      body: PageView(
        scrollDirection: Axis.horizontal,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        controller: _appPageController,
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  String searchUrl = 'http://www.reddit.com/r/totalwar/search.json?restrict_sr=on&limit=25&sort=relevance&q=';
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        hintColor: Colors.white,
        primaryColor: Colors.black,
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white
            )
        )
    );
  }

  @override
  List<Widget>buildActions(BuildContext context) =>
      [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton
        (
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) =>
      BlocProvider(
        create: (_) => NewsBloc(searchUrl + query + '&after='),
        child: News(),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [
      'Warhammer',
      'Three Kingdoms',
      'Medieval'
    ];
    return Container(
      color: Colors.grey[800],
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion, style: TextStyle(color: Colors.white),),
            onTap: () {
              query = suggestion;
            },
          );
        },
      ),
    );
  }
}
