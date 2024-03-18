import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:single_machine_cashier_ui/core/error/failures.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/discount.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/order.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/orders.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/usecases/pdf_api.dart';
part 'order_event.dart';
part 'order_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String AUTHENTICATION_FAILURE_MESSAGE =
    'Session ended, Please sign in again';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Orders orders;
  OrderBloc({required this.orders})
      : super(const OrderInitial(
            orderItems: [], totalPrice: 0, orderDiscounts: [])) {
    on<AddItemToOrder>(_onAddItemToOrder);
    on<RemoveItemFromOrder>(_onRemoveItemFromOrder);
    on<FinishOrder>(_onFinishOrder);
    on<CreateInvoice>(_onCreateInvoice);
    on<DeleteOrder>(_onDeleteOrder);
    on<SubtractFromItemQuantity>(_onSubtractFromItemQuantity);
    on<AddDiscountToItem>(_onAddDiscountToItem);
    on<UpdateOrderAndTotalPrice>(_onUpdateOrderAndTotalPrice);
    on<RemoveDiscountFromItem>(_onRemoveDiscountFromItem);
    on<AddDiscountToOrder>(_onAddDiscountToOrder);
    on<RemoveDiscountFromOrder>(_onRemoveDiscountFromOrder);
  }

  FutureOr<void> _onAddItemToOrder(
      AddItemToOrder event, Emitter<OrderState> emit) {
    final List<Item> updatedOrderItems = [];
    updatedOrderItems.addAll(state.orderItems);
    final existingProductIndex = updatedOrderItems.indexWhere(
      (item) => item.id == event.item.id,
    );

    if (existingProductIndex != -1) {
      // If the product is already in the order, increase its quantity
      double quantity = event.quantity ??
          updatedOrderItems[existingProductIndex].quantity + 1;
      Item updatedItem = Item.copyWithQuantity(
          updatedOrderItems[existingProductIndex], quantity);
      updatedOrderItems[existingProductIndex] = updatedItem;
    } else {
      // If the product is not in the order, add it with a quantity of 1
      updatedOrderItems.add(event.item);
    }

    add(UpdateOrderAndTotalPrice(
        updatedOrder: updatedOrderItems,
        updatedDiscounts: state.orderDiscounts));
  }

  FutureOr<void> _onRemoveItemFromOrder(
      RemoveItemFromOrder event, Emitter<OrderState> emit) {
    final List<Item> updatedOrderItems = [];
    event.item.discountPercentages = [];
    updatedOrderItems.addAll(state.orderItems);
    updatedOrderItems.remove(event.item);
    add(UpdateOrderAndTotalPrice(updatedOrder: updatedOrderItems));
  }

  FutureOr<void> _onFinishOrder(
      FinishOrder event, Emitter<OrderState> emit) async {
    try {
      emit(SaveLoading(
          orderDiscounts: state.orderDiscounts,
          orderItems: state.orderItems,
          totalPrice: state.totalPrice));
      final Order order = Order(
          paymentMethod: PaymentMethod.cash,
          issueDate: DateTime.now(),
          items: state.orderItems,
          orderDiscounts: state.orderDiscounts.map(
            (discount) {
              double originalPrice = state.totalPrice / (1 - discount);
              double discountAmount = originalPrice - state.totalPrice;
              return Discount(grossAmount: discountAmount);
            },
          ).toList());
      add(CreateInvoice(order: order));
      final response = await orders.saveOrder(order: order);
      response.fold((failure) {
        if (failure is AuthenticationFailure) {
          emit(OrderSessionEndedState(
              orderDiscounts: state.orderDiscounts,
              orderItems: state.orderItems,
              totalPrice: state.totalPrice));
        } else {
          emit(OrderError(
              message: _mapFailureToMessage(failure),
              orderItems: state.orderItems,
              totalPrice: state.totalPrice,
              orderDiscounts: state.orderDiscounts));
        }
      }, (items) {
        add(UpdateOrderAndTotalPrice(
            updatedOrder: event.subOrder != null ? event.restOfOrderItems! : [],
            updatedDiscounts:
                event.subOrder != null ? state.orderDiscounts : []));
      });
    } catch (e) {
      emit(OrderError(
          message: 'Error saving order: $e',
          orderItems: state.orderItems,
          totalPrice: state.totalPrice,
          orderDiscounts: state.orderDiscounts));
    }
  }

  FutureOr<void> _onDeleteOrder(DeleteOrder event, Emitter<OrderState> emit) {
    emit(const OrderUpdated(updatedOrderItems: [], total: 0, discounts: []));
  }

  FutureOr<void> _onSubtractFromItemQuantity(
      SubtractFromItemQuantity event, Emitter<OrderState> emit) {
    final List<Item> updatedOrderItems = [];
    updatedOrderItems.addAll(state.orderItems);
    final existingProductIndex = updatedOrderItems.indexWhere(
      (item) => item.id == event.item.id,
    );

    if (existingProductIndex != -1) {
      // If the product is already in the order, increase its quantity
      if (updatedOrderItems[existingProductIndex].quantity > 1) {
        double quantity = updatedOrderItems[existingProductIndex].quantity - 1;
        Item updatedItem = Item.copyWithQuantity(
            updatedOrderItems[existingProductIndex], quantity);
        updatedOrderItems[existingProductIndex] = updatedItem;
        add(UpdateOrderAndTotalPrice(updatedOrder: updatedOrderItems));
      } else {
        add(RemoveItemFromOrder(item: updatedOrderItems[existingProductIndex]));
      }
    }
  }

  FutureOr<void> _onAddDiscountToItem(
      AddDiscountToItem event, Emitter<OrderState> emit) {
    final List<Item> updatedOrderItems = [];
    updatedOrderItems.addAll(state.orderItems);
    final existingProductIndex = updatedOrderItems.indexWhere(
      (item) => item.id == event.item.id,
    );
    if (existingProductIndex != -1) {
      List<double> updatedDiscounts =
          updatedOrderItems[existingProductIndex].discountPercentages ?? [];

      updatedDiscounts.add(event.discount);
      Item updatedItem = Item.copyWithDiscount(
          updatedOrderItems[existingProductIndex], updatedDiscounts);

      updatedOrderItems[existingProductIndex] = updatedItem;
    }

    add(UpdateOrderAndTotalPrice(updatedOrder: updatedOrderItems));
  }

  FutureOr<void> _onUpdateOrderAndTotalPrice(
      UpdateOrderAndTotalPrice event, Emitter<OrderState> emit) {
    double totalPrice = 0;

    for (var i = 0; i < event.updatedOrder.length; i++) {
      totalPrice += event.updatedOrder[i].netAmount;
    }
    if (event.updatedDiscounts != null) {
      double totalDiscounts = 1;
      for (var i = 0; i < event.updatedDiscounts!.length; i++) {
        totalDiscounts *= 1 - event.updatedDiscounts![i];
      }
      totalPrice *= totalDiscounts;
    }

    emit(OrderUpdated(
        updatedOrderItems: event.updatedOrder,
        total: totalPrice,
        discounts: event.updatedDiscounts ?? state.orderDiscounts));
  }

  FutureOr<void> _onRemoveDiscountFromItem(
      RemoveDiscountFromItem event, Emitter<OrderState> emit) {
    final List<Item> updatedOrderItems = [];
    updatedOrderItems.addAll(state.orderItems);
    final existingProductIndex = updatedOrderItems.indexWhere(
      (item) => item.id == event.item.id,
    );
    if (existingProductIndex != -1) {
      // If the product is already in the order, increase its quantity
      List<double> updatedDiscounts =
          updatedOrderItems[existingProductIndex].discountPercentages ?? [];
      updatedDiscounts.removeAt(event.discountIndex);

      Item updatedItem = Item.copyWithDiscount(
          updatedOrderItems[existingProductIndex], updatedDiscounts);

      updatedOrderItems[existingProductIndex] = updatedItem;
    }

    add(UpdateOrderAndTotalPrice(updatedOrder: updatedOrderItems));
  }

  FutureOr<void> _onAddDiscountToOrder(
      AddDiscountToOrder event, Emitter<OrderState> emit) {
    final List<double> updatedOrderDiscounts = [];
    updatedOrderDiscounts.addAll(state.orderDiscounts);
    updatedOrderDiscounts.add(event.discount);

    add(UpdateOrderAndTotalPrice(
        updatedOrder: state.orderItems,
        updatedDiscounts: updatedOrderDiscounts));
  }

  FutureOr<void> _onRemoveDiscountFromOrder(
      RemoveDiscountFromOrder event, Emitter<OrderState> emit) {
    final List<double> updatedOrderDiscounts = [];
    updatedOrderDiscounts.addAll(state.orderDiscounts);
    updatedOrderDiscounts.removeAt(event.discountIndex);

    add(UpdateOrderAndTotalPrice(
        updatedOrder: state.orderItems,
        updatedDiscounts: updatedOrderDiscounts));
  }

  FutureOr<void> _onCreateInvoice(
      CreateInvoice event, Emitter<OrderState> emit) async {
    try {
      emit(SaveLoading(
          orderDiscounts: state.orderDiscounts,
          orderItems: state.orderItems,
          totalPrice: state.totalPrice));

      final response = await orders.createInvoice(order: event.order);
      response.fold((failure) {
        emit(OrderError(
            message: _mapFailureToMessage(failure),
            orderItems: state.orderItems,
            totalPrice: state.totalPrice,
            orderDiscounts: state.orderDiscounts));
      }, (invoiceBase64PdfData) async {
        Uint8List pdfBytes = base64Decode(invoiceBase64PdfData.split(',').last);
        PdfApi.printExternalInvoice(pdfBytes);
      });
    } catch (e) {
      emit(OrderError(
          message: 'Error saving order: $e',
          orderItems: state.orderItems,
          totalPrice: state.totalPrice,
          orderDiscounts: state.orderDiscounts));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case AuthenticationFailure:
        return AUTHENTICATION_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
