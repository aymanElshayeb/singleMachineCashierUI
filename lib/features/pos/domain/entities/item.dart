import 'package:single_machine_cashier_ui/features/pos/domain/entities/cart.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:objectbox/objectbox.dart';

import 'category.dart';

@Entity()
class Item extends Equatable {
  @Id()
  int id;

  final String name;

  final String unit;

  final bool kilo;
  final int category;

  final underCategory = ToOne<Category>();

  final underCart = ToMany<Cart>();

  final double price;

  final String PLU_EAN;

  Item(
      {required this.PLU_EAN,
      required this.name,
      required this.unit,
      required this.category,
      required this.price,
      required this.kilo,
      this.id = 0});

  factory Item.fromJson(Map<String, dynamic> jsonMap) {
    return Item(
      name: jsonMap['name'],
      category: jsonMap['category'],
      PLU_EAN: jsonMap['PLU_EAN'],
      price: jsonMap['price'],
      kilo: jsonMap['kilo'],
      unit: jsonMap['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'PLU_EAN': PLU_EAN,
      'price': price,
      'kilo': kilo,
      'unit': unit
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [PLU_EAN, name, unit, kilo, category, price, id];
}

// CREATE TABLE TBL_ARTIKEL ([ID] autoincrement, PLU varchar(24), ProdNr varchar(50),
// ProdName varchar(150), CatID int, Price double, bestand double, ProdTaxID int, ProdTax
// double, ProdColor varchar(50), SortID int, PfandID int, LieferantID int, EinheitID int,
// EKPrice double, LagerPlatz1 varchar(12), LagerPlatz2 varchar(12), OPTION1 int, OPTION2
// int, IsSerienNr int, mBestellmenge double, mBestand double, setArtikel int, ProdTax2
// double);

