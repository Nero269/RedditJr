class NewsModel{
  String title;
  String thumbnail;
  int score;
  String name;
  int num_comments;
  String id;

//<editor-fold desc="Data Methods">

  NewsModel({
    required this.title,
    required this.thumbnail,
    required this.score,
    required this.name,
    required this.num_comments,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewsModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          thumbnail == other.thumbnail &&
          score == other.score &&
          name == other.name &&
          num_comments == other.num_comments &&
          id == other.id);

  @override
  int get hashCode =>
      title.hashCode ^
      thumbnail.hashCode ^
      score.hashCode ^
      name.hashCode ^
      num_comments.hashCode ^
      id.hashCode;

  @override
  String toString() {
    return 'NewsModel{' +
        ' title: $title,' +
        ' thumbnail: $thumbnail,' +
        ' score: $score,' +
        ' name: $name,' +
        ' num_comments: $num_comments,' +
        ' id: $id,' +
        '}';
  }

  NewsModel copyWith({
    String? title,
    String? thumbnail,
    int? score,
    String? name,
    int? num_comments,
    String? id,
  }) {
    return NewsModel(
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      score: score ?? this.score,
      name: name ?? this.name,
      num_comments: num_comments ?? this.num_comments,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'thumbnail': this.thumbnail,
      'score': this.score,
      'name': this.name,
      'num_comments': this.num_comments,
      'id': this.id,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      score: map['score']?.toInt() ?? 0,
      name: map['name'] ?? '',
      num_comments: map['num_comments'] ?.toInt() ?? 0,
      id: map['id'] ?? '',
    );
  }

//</editor-fold>
}