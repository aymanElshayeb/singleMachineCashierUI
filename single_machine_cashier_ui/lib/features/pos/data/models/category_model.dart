import 'package:meta/meta.dart';
import '../../domain/entities/category.dart';


class CategoryModel extends Category {
  CategoryModel({
    @required String name,
    @required int id,
  }) : super(name: name, id: id);

  factory CategoryModel.fromJson(Map<String, dynamic> jsonMap) {
    return CategoryModel(name: jsonMap['name'], id: jsonMap['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,

    };
  }
}
