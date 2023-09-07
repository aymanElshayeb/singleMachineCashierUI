// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:objectbox/objectbox.dart';

import 'item.dart';

@Entity()
class Cart extends Equatable {
  @Id()
  int id;
  String items;
  List<double> quantities;

  Cart({
    this.items = '',
    this.quantities = const [],
    this.id = 0,
  });

  @override
  List<Object?> get props => [id, items, quantities];
}
