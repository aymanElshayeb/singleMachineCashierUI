import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/discount_list.dart';
import 'cart_item.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: height * 0.4,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: state.orderItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CartItem(orderItem: state.orderItems[index]),
                        if (state.orderItems[index].discountPercentages!.isNotEmpty)
                          DiscountList(
                            item: state.orderItems[index],
                            discounts:
                                state.orderItems[index].discountPercentages!,
                          )
                      ],
                    );
                  }),
            ),
            SizedBox(
                height: height * 0.2,
                child: DiscountList(discounts: state.orderDiscounts)),
          ],
        );
      },
    );
  }
}
