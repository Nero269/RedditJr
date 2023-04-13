import 'dart:io';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reddit_jr/Database.dart';
import 'package:reddit_jr/Model/Bookmarks.dart';
import 'package:reddit_jr/main.dart';

class Post extends StatefulWidget {
  Post({Key? key, required this.url}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String url;
  @override
  State<Post> createState() => PostState();
}

class PostState extends State<Post> {
  final dio = new Dio();
  String imageData='';
  bool existed = false;
  String author = '';
  String title = '';
  String image = '';
  String id = '';
  int score = 0;
  int comments = 0;
  bool hasThumbnail = false;
  var _post = <dynamic>[];
  @override
  void initState() {
    _getPost(widget.url);
    super.initState();
  }

  void _toNews() {
    Navigator.pop(context);
  }

  void _getPost(String url) async {
    List<dynamic> nList = <dynamic>[];

    final response = await dio.get(url);
    id=response.data[0]['data']['children'][0]['data']['id'];
    image = response.data[0]['data']['children'][0]['data']['thumbnail'];
    author = response.data[0]['data']['children'][0]['data']['author'];
    title = response.data[0]['data']['children'][0]['data']['title'];
    score = response.data[0]['data']['children'][0]['data']['score'];
    comments = response.data[0]['data']['children'][0]['data']['num_comments'];
    for (int i = 0; i < response.data[1]['data']['children'].length; i++) {
      nList.add(response.data[1]['data']['children'][i]);
    }
    if (this.mounted) {
      setState(() {
        _post.addAll(nList);
      });
    }
  }
  Future bookmarkCheck(String id) async{
    existed = await DatabaseHelper.instance.getCount(id);
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

  _asyncMethod(var url, String id) async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.
    var response = await get(Uri.parse(url)); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/'+id+'.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName);             // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
    setState(() {
      imageData = filePathAndName;
    });
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
                Text('Posted by ' + author,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 10)),
                Text(
                  title,
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
                    child: imageCheck(image)
                        ? Image(image: NetworkImage(image), fit: BoxFit.fill)
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
                    Text(score.toString(),
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
                    Text(comments.toString(),
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await bookmarkCheck(this.id);
                          await _asyncMethod(image, author);
                          if(!existed) {
                            await DatabaseHelper.instance.add(Bookmarks(
                                title: this.title,
                                postID: this.id,
                                score: this.score,
                                comments: this.comments,
                                thumbnail: this.imageData));
                            Fluttertoast.showToast(
                                msg: "Post Bookmarked",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Error: This Post was already bookmarked",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Icon(
                          Icons.bookmark_add,
                          color: Colors.white,
                        )),
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: Colors.grey[700],
                child: Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  child: ListView.builder(
                      itemCount: _post.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.grey[800],
                          child: Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.0))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'By ' + _post[index]['data']['author'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _post[index]['data']['body'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.thumb_up,
                                      color: Colors.white,
                                    ),
                                    Text(
                                        _post[index]['data']['score']
                                            .toString(),
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
