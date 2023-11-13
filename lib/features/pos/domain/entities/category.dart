import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firedart/firestore/models.dart';

class Category extends Equatable {
  final String id;
  final String name;

  const Category({
    required this.name,
    this.id = '0',
  });

  factory Category.empty() {
    return const Category(name: 'empty', id: '0');
  }

  @override
  List<Object?> get props => [id, name];
  static Category fromSnapshot(Document snap) =>
      Category(name: snap['category']['name'], id: snap.id);

  static Category fireBaseFromSnapshot(DocumentSnapshot snap) =>
      Category(name: snap['category']['name'], id: snap.id);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}
