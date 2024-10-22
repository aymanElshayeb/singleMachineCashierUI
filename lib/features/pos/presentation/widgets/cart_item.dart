import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'discount_dialog.dart';

class CartItem extends StatelessWidget {
  final Item orderItem;

  const CartItem({
    Key? key,
    required this.orderItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.2,
      child: Card(
          color: Theme.of(context).cardColor,
          semanticContainer: true,
          child: ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: 4),
            title: Text(
              orderItem.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: height * 0.022),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderItem.unitPrice.toString(),
                    style: TextStyle(fontSize: height * 0.022)),
                discountButton(context, height)
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                deleteButton(context, height),
                Text((orderItem.unitPrice * orderItem.quantity).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: height * 0.019)),
                Container(
                  width: width * 0.06,
                  height: height * 0.034,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        subtractButton(context),
                        quantityButton(context),
                        addButton(context)
                      ]),
                ),
              ],
            ),
          )),
    );
  }

  Widget discountButton(BuildContext context, double height) {
    return InkWell(
      child: Icon(Icons.discount, size: height * 0.027),
      onTap: () {
        showDialog(
            context: context,
            builder: ((context) => DiscountDialog(
                  onPressed: (discount) {
                    BlocProvider.of<OrderBloc>(context).add(
                        AddDiscountToItem(item: orderItem, discount: discount));
                  },
                  title: orderItem.name,
                )));
      },
    );
  }

  Widget deleteButton(BuildContext context, double height) {
    return InkWell(
      onTap: (() {
        BlocProvider.of<OrderBloc>(context)
            .add(RemoveItemFromOrder(item: orderItem));
      }),
      child: Icon(Icons.delete, size: height * 0.029),
    );
  }

  Widget subtractButton(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.remove),
      onTap: () {
        BlocProvider.of<OrderBloc>(context)
            .add(SubtractFromItemQuantity(item: orderItem));
      },
    );
  }

  Widget addButton(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.add),
      onTap: () {
        BlocProvider.of<OrderBloc>(context)
            .add(AddItemToOrder(item: orderItem));
      },
    );
  }

  Widget quantityButton(BuildContext context) {
    return InkWell(
      onTap: (() {
        showDialog(
            context: context,
            builder: (((cc) {
              return QuantityDialog(item: orderItem);
            })));
      }),
      child: Text(orderItem.quantity.toString()),
    );
  }
}
