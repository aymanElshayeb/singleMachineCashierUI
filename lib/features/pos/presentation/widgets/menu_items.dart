import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          height: height * 0.9,
          width: width * 0.66,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15)),
          child: GridView.builder(
            itemCount:
                state.categories.length, //should be length of the items list
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height * 0.5),
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: 10,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.primaries[index].withOpacity(0.5),
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: (() {
                        if (!state.gotitems) {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(GetCategoryItems(index + 1));
                        } else {
                          BlocProvider.of<CategoryBloc>(context).add(
                              UpdateOrderEvent(state.categoryitems[index],
                                  state.categoryitems));
                        }
                      }),
                      child: Column(
                        children: [
                          Text(state.categories[index]),
                          Container(
                              child: state.gotitems == false
                                  ? Text("")
                                  : Text(state.categoryitems[index].price
                                      .toString()))
                        ],
                      )));
            },
          ),
        );
      },
    );
  }
}
