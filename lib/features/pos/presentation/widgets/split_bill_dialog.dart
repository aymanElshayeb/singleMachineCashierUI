import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/domain/entities/item.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/screens/payment_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplitBill extends StatefulWidget {
  final List<Item> subOrderItems = [];
  final List<Item> orderItems = [];

  SplitBill({Key? key}) : super(key: key);

  @override
  State<SplitBill> createState() => _SplitBillState();
}

class _SplitBillState extends State<SplitBill> {
  @override
  void initState() {
    super.initState();
    widget.orderItems
        .addAll(BlocProvider.of<OrderBloc>(context).state.orderItems);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.splitbill),
      content: SizedBox(
        width: width * 0.65,
        height: height * 0.6,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          order(
            width * 0.3,
            height * 0.6,
            context,
          ),
          subOrder(
            width * 0.3,
            height * 0.6,
            context,
          ),
        ]),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            List<double> discountPercentages =
                BlocProvider.of<OrderBloc>(context).state.orderDiscounts;
            double totalDiscounts = 1;
            double totalPrice = 0;
            for (var i = 0; i < discountPercentages.length; i++) {
              totalDiscounts *= 1 - discountPercentages[i];
            }
            for (var i = 0; i < widget.subOrderItems.length; i++) {
              totalPrice += widget.subOrderItems[i].getNetPrice();
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => PaymentScreen(
                        subOrder: widget.subOrderItems,
                        restOfOrder: widget.orderItems,
                        totalPrice: totalPrice * totalDiscounts))));
            setState(() {
              widget.subOrderItems.clear();
            });
          },
          child: Text(AppLocalizations.of(context)!.pay),
        )
      ],
    );
  }

  Widget order(
    double width,
    double height,
    BuildContext context,
  ) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15)),
      child: widget.orderItems.isNotEmpty
          ? ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (cc, index) {
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(widget.orderItems.elementAt(index).name),
                        subtitle: Text(widget.orderItems
                            .elementAt(index)
                            .price
                            .toString()),
                        trailing: Column(children: [
                          Text(widget.orderItems
                              .elementAt(index)
                              .quantity
                              .toString()),
                          InkWell(
                            child: const Icon(Icons.drive_file_move_outlined),
                            onTap: () {
                              if (widget.subOrderItems
                                  .contains(widget.orderItems[index])) {
                                setState(() {
                                  int itemIndex = widget.subOrderItems
                                      .indexOf(widget.orderItems[index]);
                                  widget.subOrderItems[itemIndex] =
                                      Item.copyWithQuantity(
                                          widget.subOrderItems[itemIndex],
                                          widget.subOrderItems[itemIndex]
                                                  .quantity +
                                              1);
                                  widget.orderItems[index] =
                                      Item.copyWithQuantity(
                                          widget.orderItems[index],
                                          widget.orderItems[index].quantity -
                                              1);
                                });
                              } else {
                                setState(() {
                                  widget.subOrderItems.add(
                                      Item.copyWithQuantity(
                                          widget.orderItems[index], 1));
                                  widget.orderItems[index] =
                                      Item.copyWithQuantity(
                                          widget.orderItems[index],
                                          widget.orderItems[index].quantity -
                                              1);
                                });
                              }
                              if (widget.orderItems[index].quantity == 0) {
                                setState(() {
                                  widget.orderItems.removeAt(index);
                                });
                              }
                            },
                          )
                        ]),
                        onTap: () {
                          setState(() {
                            int indexOfItem = widget.subOrderItems
                                .indexOf(widget.orderItems[index]);
                            if (indexOfItem != -1) {
                              widget.subOrderItems[indexOfItem] =
                                  Item.copyWithQuantity(
                                      widget.subOrderItems[indexOfItem],
                                      widget.subOrderItems[indexOfItem]
                                              .quantity +
                                          widget.orderItems[index].quantity);
                            } else {
                              widget.subOrderItems
                                  .add(widget.orderItems[index]);
                            }
                            widget.orderItems.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              })
          : const Center(child: Text('Order')),
    );
  }

  Widget subOrder(
    double width,
    double height,
    BuildContext context,
  ) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15)),
      child: widget.subOrderItems.isNotEmpty
          ? ListView.builder(
              itemCount: widget.subOrderItems.length,
              itemBuilder: (cc, index) {
                return Card(
                  child: ListTile(
                    title: Text(widget.subOrderItems.elementAt(index).name),
                    subtitle: Text(
                        widget.subOrderItems.elementAt(index).price.toString()),
                    trailing: Column(children: [
                      Text(widget.subOrderItems
                          .elementAt(index)
                          .quantity
                          .toString()),
                      InkWell(
                        child: const Icon(Icons.drive_file_move_rtl_outlined),
                        onTap: () {
                          if (widget.orderItems
                              .contains(widget.subOrderItems[index])) {
                            setState(() {
                              int itemIndex = widget.orderItems
                                  .indexOf(widget.subOrderItems[index]);
                              widget.orderItems[itemIndex] =
                                  Item.copyWithQuantity(
                                      widget.orderItems[itemIndex],
                                      widget.orderItems[itemIndex].quantity +
                                          1);
                              widget.subOrderItems[index] =
                                  Item.copyWithQuantity(
                                      widget.subOrderItems[index],
                                      widget.subOrderItems[index].quantity - 1);
                            });
                          } else {
                            setState(() {
                              widget.orderItems.add(Item.copyWithQuantity(
                                  widget.subOrderItems[index], 1));
                              widget.subOrderItems[index] =
                                  Item.copyWithQuantity(
                                      widget.subOrderItems[index],
                                      widget.subOrderItems[index].quantity - 1);
                            });
                          }
                          if (widget.subOrderItems[index].quantity == 0) {
                            setState(() {
                              widget.subOrderItems.removeAt(index);
                            });
                          }
                        },
                      )
                    ]),
                    onTap: () {
                      setState(() {
                        int indexOfItem = widget.orderItems
                            .indexOf(widget.subOrderItems[index]);
                        if (indexOfItem != -1) {
                          widget.orderItems[indexOfItem] =
                              Item.copyWithQuantity(
                                  widget.orderItems[indexOfItem],
                                  widget.orderItems[indexOfItem].quantity +
                                      widget.subOrderItems[index].quantity);
                        } else {
                          widget.orderItems.add(widget.subOrderItems[index]);
                        }
                        widget.subOrderItems.removeAt(index);
                      });
                    },
                  ),
                );
              })
          : const Center(child: Text('Sub-order')),
    );
  }
}
