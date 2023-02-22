part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class getCash extends PaymentEvent {
  final String digit_string;

  getCash({@required this.digit_string});
}

class AddToCash extends PaymentEvent {
  final num money;

  AddToCash({@required this.money});
}

class DeleteFromCash extends PaymentEvent {}

class UpdateMethod extends PaymentEvent {
  final String method;

  UpdateMethod({@required this.method});
}

class getTotal extends PaymentEvent {
  final num total;

  getTotal({@required this.total});
}
