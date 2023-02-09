import 'package:equatable/equatable.dart';
import 'item.dart';
import 'package:meta/meta.dart';

class Cart extends Equatable{

  List<Item> items;

  Cart({
    @required this.items,
  }):super([items]);

}

