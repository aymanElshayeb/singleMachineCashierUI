part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class getCash extends PaymentEvent {
  final String digit_string;

  getCash({@required this.digit_string});
}

class AddToCash extends PaymentEvent {
  final double money;

  AddToCash({@required this.money});
}

class UpdateMethod extends PaymentEvent {
  final String method;

  UpdateMethod({@required this.method});
}

class getTotal extends PaymentEvent {
  final double total;

  getTotal({@required this.total});
}
