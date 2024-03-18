import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:single_machine_cashier_ui/components/menu_background.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/bloc/categories/category_bloc.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/items_list.dart';
import 'package:single_machine_cashier_ui/features/pos/presentation/widgets/session_ended_dialog.dart';
import '../widgets/bill.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/category_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      const MainAppBar(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Bill(),
            BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is SessionEndedState) {
                  showDialog(
                    context: context,
                    builder: (context) => const SessionEndedDialog(),
                  );
                }
              },
              builder: (context, state) {
                return MenuBackground(
                    content: state is NavigateToItemsState
                        ? ItemsList(
                            categoryId: state.categoryId,
                          )
                        : const CategoryList());
              },
            )
          ],
        ),
      )
    ]));
  }
}
