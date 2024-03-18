part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  final List<Item> orderItems;
  final double totalPrice;
  final List<double> orderDiscounts;
  const OrderState(
      {required this.orderItems,
      required this.totalPrice,
      required this.orderDiscounts});

  @override
  List<Object> get props => [orderItems, totalPrice];
}

final class OrderInitial extends OrderState {
  const OrderInitial(
      {required super.orderItems,
      required super.totalPrice,
      required super.orderDiscounts});
}

class SaveLoading extends OrderState {
  const SaveLoading(
      {required super.orderItems,
      required super.totalPrice,
      required super.orderDiscounts});
}

class SaveCompleted extends OrderState {
  const SaveCompleted(
      {required super.orderItems,
      required super.totalPrice,
      required super.orderDiscounts});
}

class OrderUpdated extends OrderState {
  final List<Item> updatedOrderItems;
  final double total;
  final List<double> discounts;

  const OrderUpdated(
      {required this.updatedOrderItems,
      required this.total,
      required this.discounts})
      : super(
            orderItems: updatedOrderItems,
            totalPrice: total,
            orderDiscounts: discounts);
  @override
  List<Object> get props => [updatedOrderItems, total, discounts];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(
      {required this.message,
      required super.orderItems,
      required super.totalPrice,
      required super.orderDiscounts});
}

class OrderSessionEndedState extends OrderState {
  const OrderSessionEndedState(
      {required super.orderItems,
      required super.totalPrice,
      required super.orderDiscounts});
}
