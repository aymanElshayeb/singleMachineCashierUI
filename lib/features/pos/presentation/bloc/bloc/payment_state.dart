part of 'payment_bloc.dart';

@immutable
abstract class PaymentState extends Equatable {
  PaymentState([List props = const <dynamic>[]]) : super(props);
  double get total => 0;
  double get cash => 0;
  double get inreturn => 0;
  String get selectedMethod => "Cash";
}

class PaymentInitial extends PaymentState {}

class UpdatePaymentState extends PaymentState {
  final double final_cash;
  final double final_total;
  final double final_return;
  final String final_selected;
  @override
  double get total => final_total;
  @override
  double get cash => final_cash;
  @override
  double get inreturn => final_return;
  @override
  String get selectedMethod => final_selected;
  UpdatePaymentState(
      {@required this.final_cash,
      @required this.final_total,
      @required this.final_return,
      @required this.final_selected})
      : super([final_cash, final_total, final_return, final_selected]);
}
