import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/categories/category_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      bloc: BlocProvider.of(context)..add(FetchCategoriesEvent()),
      builder: (context, state) {
        if (state is ErrorState) {
          return Center(
            child: Text('error message:${state.errorMessage}'),
          );
        } else if (state is CategoriesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoriesLoadedState) {
          return GridView.builder(
            itemCount:
                state.categories.length, //should be length of the items list
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height * 0.5),
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  width: 10,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.primaries[index].withOpacity(0.5),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: (() {
                        BlocProvider.of<CategoryBloc>(context).add(
                            NavigateToItemsEvent(
                                categoryId: state.categories[index].id));
                      }),
                      child: Text(state.categories[index].name)));
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
