import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Category extends Equatable {
  final String name;
  final int id;

  Category({
    @required this.name,
    @required this.id,
  }) : super([name, id]);
  factory Category.fromJson(Map<String, dynamic> jsonMap) {
    return Category(name: jsonMap['name'], id: jsonMap['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
