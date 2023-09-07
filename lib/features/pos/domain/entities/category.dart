import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:objectbox/objectbox.dart';

import 'item.dart';

@Entity()
class Category extends Equatable {
  final String name;
  @Id()
  int id;
  @Backlink()
  final items = ToMany<Item>();

  Category({
    required this.name,
    this.id = 0,
  });
  factory Category.fromJson(Map<String, dynamic> jsonMap) {
    return Category(name: jsonMap['name'], id: jsonMap['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  @override
  List<Object?> get props => [name, id];
}
