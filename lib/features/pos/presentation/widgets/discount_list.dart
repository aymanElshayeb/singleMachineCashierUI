import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';

class DiscountList extends StatelessWidget {
  final Item? item;
  final List<double> discounts;
  const DiscountList({super.key, this.item, required this.discounts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          itemCount: discounts.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Text('${discounts[index] * 100}%'),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (item != null) {
                        BlocProvider.of<OrderBloc>(context).add(
                            RemoveDiscountFromItem(
                                item: item!, discountIndex: index));
                      } else {
                        BlocProvider.of<OrderBloc>(context)
                            .add(RemoveDiscountFromOrder(discountIndex: index));
                      }
                    }),
              ),
            );
          }),
    );
  }
}
