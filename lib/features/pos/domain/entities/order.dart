import 'package:equatable/equatable.dart';
import 'package:firedart/firestore/models.dart';

enum PaymentMethod { cash, card }

class Order extends Equatable {
  final String id;
  final double totalPrice;
  final PaymentMethod paymentMethod;
  final DateTime dateTime;

  const Order(
      {required this.totalPrice,
      required this.paymentMethod,
      required this.dateTime,
      this.id = '0'});

  @override
  List<Object?> get props => [id, totalPrice, paymentMethod, dateTime];
  static Order fromSnapshot(Document snap) {
    return Order(
        id: snap.id,
        totalPrice: snap['order']['totalPrice'],
        paymentMethod: snap['order']['paymentMethod'] == 'cash'
            ? PaymentMethod.cash
            : PaymentMethod.card,
        dateTime:
            DateTime.fromMillisecondsSinceEpoch(snap['order']['dateTime']));
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}
