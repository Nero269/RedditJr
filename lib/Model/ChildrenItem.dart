import 'package:reddit_jr/Model/NewsModel.dart';

class ChildrenItem{
  NewsModel data;
  String kind;

//<editor-fold desc="Data Methods">

  ChildrenItem({
    required this.data,
    required this.kind,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenItem &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          kind == other.kind);

  @override
  int get hashCode => data.hashCode ^ kind.hashCode;

  @override
  String toString() {
    return 'ChildrenItem{' + ' data: $data,' + ' kind: $kind,' + '}';
  }

  ChildrenItem copyWith({
    NewsModel? data,
    String? kind,
  }) {
    return ChildrenItem(
      data: data ?? this.data,
      kind: kind ?? this.kind,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': this.data,
      'kind': this.kind,
    };
  }

  factory ChildrenItem.fromMap(Map<String, dynamic> map) {
    return ChildrenItem(
      data: NewsModel.fromMap(map['data']) ,
      kind: map['kind'] ?? '',
    );
  }

//</editor-fold>
}