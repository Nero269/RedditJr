
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reddit_jr/BookmarkedPost.dart';
import 'package:reddit_jr/Database.dart';
import 'package:reddit_jr/Model/Bookmarks.dart';
import 'package:reddit_jr/post.dart';

class Bookmarked extends StatefulWidget {
  const Bookmarked({Key? key}) : super(key: key);

  @override
  State<Bookmarked> createState() => _BookmarkedState();
}

bool imageCheck(String thumbnail) {
  if (thumbnail == 'self')
    return true;
  else if (thumbnail == 'nsfw')
    return true;
  else if (thumbnail == 'spoiler')
    return true;
  else
    return false;
}



class _BookmarkedState extends State<Bookmarked> {
  void _toPost(String title, String thumbnail, int score, int comments) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookmarkedPost(
              title: title, thumbnail: thumbnail, score: score, comments: comments,)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Bookmarks>>(
        future: DatabaseHelper.instance.getBookmarks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Bookmarks>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          return Container(
            color: Colors.grey[900],
            child: ListView(
                children: snapshot.data!.map((bookmarks) {
              return Center(
                  child: Container(
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
                          _toPost(bookmarks.title, bookmarks.thumbnail, bookmarks.score, bookmarks.comments);
                        },
                        child: Text(
                          bookmarks.title,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: imageCheck(bookmarks.thumbnail)
                              ? Text('(No Image)',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white54))
                              : Image(image: FileImage(File(bookmarks.thumbnail)), fit: BoxFit.fill),
                                  ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                          ),
                          Text(bookmarks.score.toString(),
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
                          Text(bookmarks.comments.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  DatabaseHelper.instance.remove(bookmarks.id!);
                                });
                                Fluttertoast.showToast(
                                    msg: "Post unbooked",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              },
                              child: Icon(Icons.bookmark_remove, color: Colors.white,)),
                        ],
                      )
                    ],
                  ),
                ),
              ));
            }).toList()),
          );
        },
      ),
    );
  }
}
