import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable{

  final int id;
  final String name;
  final String unit;
  final bool kilo;
  final int category;
  final double price;
  final String PLU_EAN;


  Item({
    @required this.PLU_EAN, @required this.name, @required this.unit, @required this.category,
    @required this.price, @required this.kilo, @required this.id
  } ):super([PLU_EAN,name,unit,kilo,category,price,id]);

}

// CREATE TABLE TBL_ARTIKEL ([ID] autoincrement, PLU varchar(24), ProdNr varchar(50),
// ProdName varchar(150), CatID int, Price double, bestand double, ProdTaxID int, ProdTax
// double, ProdColor varchar(50), SortID int, PfandID int, LieferantID int, EinheitID int,
// EKPrice double, LagerPlatz1 varchar(12), LagerPlatz2 varchar(12), OPTION1 int, OPTION2
// int, IsSerienNr int, mBestellmenge double, mBestand double, setArtikel int, ProdTax2
// double);

