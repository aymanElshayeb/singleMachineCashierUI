part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  num get total => 0;
  num get cash => 0;
  num get inreturn => 0;
  String? get selectedMethod => "Cash";
  @override
  List<Object> get props => [
        total,
        cash,
        inreturn,
      ];
}

class PaymentInitial extends PaymentState {}

class UpdatePaymentState extends PaymentState {
  final num final_cash;
  final num final_total;
  final num final_return;
  final String? final_selected;
  @override
  num get total => final_total;
  @override
  num get cash => final_cash;
  @override
  num get inreturn => final_return;
  @override
  String? get selectedMethod => final_selected;
  UpdatePaymentState(
      {required this.final_cash,
      required this.final_total,
      required this.final_return,
      required this.final_selected});
}
