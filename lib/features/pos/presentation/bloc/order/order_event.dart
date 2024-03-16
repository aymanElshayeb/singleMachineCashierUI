part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddItemToOrder extends OrderEvent {
  final Item item;
  final double? quantity;
  const AddItemToOrder({required this.item, this.quantity});
}

class UpdateOrderAndTotalPrice extends OrderEvent {
  final List<Item> updatedOrder;
  final List<double>? updatedDiscounts;
  const UpdateOrderAndTotalPrice(
      {required this.updatedOrder, this.updatedDiscounts});
}

class RemoveItemFromOrder extends OrderEvent {
  final Item item;
  const RemoveItemFromOrder({required this.item});
}

class SubtractFromItemQuantity extends OrderEvent {
  final Item item;
  const SubtractFromItemQuantity({required this.item});
}

class AddDiscountToItem extends OrderEvent {
  final Item item;
  final double discount;
  const AddDiscountToItem({required this.item, required this.discount});
}

class RemoveDiscountFromItem extends OrderEvent {
  final Item item;
  final int discountIndex;
  const RemoveDiscountFromItem(
      {required this.item, required this.discountIndex});
}

class AddDiscountToOrder extends OrderEvent {
  final double discount;
  const AddDiscountToOrder({required this.discount});
}

class RemoveDiscountFromOrder extends OrderEvent {
  final int discountIndex;
  const RemoveDiscountFromOrder({required this.discountIndex});
}

class FinishOrder extends OrderEvent {
  final List<Item>? subOrder;
  final List<Item>? restOfOrderItems;
  final double? totalPrice;
  final PaymentMethod paymentMethod;
  const FinishOrder({
    this.subOrder,
    this.restOfOrderItems,
    required this.paymentMethod,
    this.totalPrice,
  });
}

class CreateInvoice extends OrderEvent {
  final Order order;

  const CreateInvoice({required this.order});
}

class DeleteOrder extends OrderEvent {}
