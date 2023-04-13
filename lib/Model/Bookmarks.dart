import 'dart:convert';

class Bookmarks {
  final int? id;
  final String postID;
  final String title;
  final String thumbnail;
  final int score;
  final int comments;

  Bookmarks(
      {this.id,
        required this.postID,
        required this.title,
        required this.thumbnail,
        required this.score,
        required this.comments});


  factory Bookmarks.fromMap(Map<String, dynamic> json) => new Bookmarks(
        id: json['id'],
        postID: json['postID'],
        title: json['title'],
        thumbnail: json['thumbnail'],
        score: json['score'],
        comments: json['comments'],
      );
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'postID': this.postID,
      'title': this.title,
      'thumbnail': this.thumbnail,
      'score': this.score,
      'comments': this.comments,
    };
  }
}