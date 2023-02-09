import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';

class ListViewTable extends StatelessWidget {
  int length;
  @override
  Widget build(BuildContext context) {
    BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: 5,
          itemBuilder: ((context, index) {
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }),
        );
      },
    );
  }
}
