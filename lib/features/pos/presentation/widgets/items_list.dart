import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/order/order_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/item/bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/session_ended_dialog.dart';

class ItemsList extends StatelessWidget {
  final String categoryId;
  const ItemsList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, ItemState>(
      bloc: BlocProvider.of(context)..add(LoadItems(categoryId)),
      listener: (context, state) {
        if (state is SessionEndedState) {
                  showDialog(
                    context: context,
                    builder: (context) => const SessionEndedDialog(),
                  );
                }
      },
      builder: (context, state) {
            if (state is ItemError) {
              return Center(
                child: Text('error message:${state.message}'),
              );
            } else if (state is ItemsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ItemsLoaded) {
              return GridView.builder(
  itemCount: state.items.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    childAspectRatio: 2.0, 
    crossAxisCount: 4,
    crossAxisSpacing: 4.0,
    mainAxisSpacing: 4.0,
  ),
  itemBuilder: (BuildContext context, int index) {
    // Ensure that the color index is within bounds
    final color = Colors.primaries[index % Colors.primaries.length].withOpacity(0.5);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () {
        BlocProvider.of<OrderBloc>(context)
            .add(AddItemToOrder(item: state.items[index]));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
        children: [
          Text(state.items[index].name),
          Text(state.items[index].unitPrice.toString()),
        ],
      ),
    );
  },
);

            }
            return const Center(
              child: Text('unknown state'),
            );
          },
    );
  }
}
