import 'package:reddit_jr/Model/ChildrenItem.dart';
import 'package:reddit_jr/Model/NewsModel.dart';

class DataModel{
  List<ChildrenItem> children;
  String after;

//<editor-fold desc="Data Methods">

  DataModel({
    required this.children,
    required this.after,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataModel &&
          runtimeType == other.runtimeType &&
          children == other.children &&
          after == other.after);

  @override
  int get hashCode => children.hashCode ^ after.hashCode;

  @override
  String toString() {
    return 'DataModel{' + ' children: $children,' + ' after: $after,' + '}';
  }

  DataModel copyWith({
    List<ChildrenItem>? children,
    String? after,
  }) {
    return DataModel(
      children: children ?? this.children,
      after: after ?? this.after,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'children': this.children,
      'after': this.after,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      children: List<ChildrenItem>.from(map['children']?.map((x) => ChildrenItem.fromMap(x))),
      after: map['after'] ?? '',
    );
  }

//</editor-fold>
}