import 'dart:io';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reddit_jr/Database.dart';
import 'package:reddit_jr/Model/Bookmarks.dart';
import 'package:reddit_jr/main.dart';

class BookmarkedPost extends StatefulWidget {
  BookmarkedPost({Key? key, required this.title, required this.thumbnail, required this.score, required this.comments}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title, thumbnail;
  final int score, comments;
  @override
  State<BookmarkedPost> createState() => BookmarkedPostState();
}

class BookmarkedPostState extends State<BookmarkedPost> {
  bool hasThumbnail = false;
  var _post = <dynamic>[];
  @override
  void initState() {
    super.initState();
  }

  void _toNews() {
    Navigator.pop(context);
  }

  bool imageCheck(String image) {
    if (image == 'self')
      return false;
    else if (image == 'nsfw')
      return false;
    else if (image == 'spoiler')
      return false;
    else if (image == '')
      return false;
    else
      return true;
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Post', textAlign: TextAlign.center),

        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              _toNews();
            }),

        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              color: Colors.grey[900],
              child: Column(children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    child: imageCheck(widget.thumbnail)
                        ? Image(image: FileImage(File(widget.thumbnail)), fit: BoxFit.fill)
                        : Text('(No Image)',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.white54))),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                    ),
                    Text(widget.score.toString(),
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
                    Text(widget.comments.toString(),
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
