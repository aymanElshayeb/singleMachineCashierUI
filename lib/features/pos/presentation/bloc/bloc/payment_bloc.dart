import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  @override
  // TODO: implement initialState
  PaymentState get initialState => PaymentInitial();

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is getCash) {
      yield UpdatePaymentState(
          final_cash: getTotalCash(event.digit_string),
          final_total: state.total,
          final_return: state.inreturn,
          final_selected: state.selectedMethod);
      if (state.cash > state.total) {
        yield UpdatePaymentState(
            final_return: state.cash - state.total,
            final_cash: state.cash,
            final_total: state.total,
            final_selected: state.selectedMethod);
      } else {
        yield UpdatePaymentState(
            final_return: 0,
            final_cash: state.cash,
            final_total: state.total,
            final_selected: state.selectedMethod);
      }
    } else if (event is getTotal) {
      yield UpdatePaymentState(
          final_total: event.total,
          final_cash: state.cash,
          final_return: state.inreturn,
          final_selected: state.selectedMethod);
    } else if (event is AddToCash) {
      yield UpdatePaymentState(
          final_cash: state.cash + event.money,
          final_total: state.total,
          final_return: state.inreturn,
          final_selected: state.selectedMethod);
      if (state.cash > state.total) {
        yield UpdatePaymentState(
            final_return: state.cash - state.total,
            final_cash: state.cash,
            final_total: state.total,
            final_selected: state.selectedMethod);
      } else {
        yield UpdatePaymentState(
            final_return: 0,
            final_cash: state.cash,
            final_total: state.total,
            final_selected: state.selectedMethod);
      }
    } else if (event is UpdateMethod) {
      yield UpdatePaymentState(
          final_cash: state.cash,
          final_total: state.total,
          final_return: state.inreturn,
          final_selected: event.method);
    }
  }

  double getTotalCash(String digit) {
    if (state.cash == 0) {
      return double.parse(digit);
    } else {
      return double.parse(state.cash.toString() + digit);
    }
  }
}
