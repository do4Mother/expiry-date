import 'package:expiry/utils/constant.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:expiry/views/home/widgets/no_items.dart';
import 'package:expiry/views/product/add_product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/product.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Date'),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.menu),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push(AddProductView.routeName),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            BlocBuilder<ListProductBloc, ListProductState>(
              builder: (context, state) {
                if (state is ListProductLoaded && state.data.isEmpty) {
                  return const SliverToBoxAdapter();
                }
                return SliverList(
                  delegate: SliverChildListDelegate([
                    kVerticalMediumBox,
                    Padding(
                      padding: kPaddingItemView,
                      child: Text(
                        'List of items',
                        style: textTheme.headline4,
                      ),
                    )
                  ]),
                );
              },
            ),
          ];
        },
        body: BlocBuilder<ListProductBloc, ListProductState>(
          builder: (context, state) {
            if (state is ListProductLoaded) {
              if (state.data.isEmpty) {
                return const NoItems();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 8 / 11,
                  crossAxisSpacing: 8,
                ),
                padding: kPaddingListView,
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return AppProduct(
                    product: state.data[index],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
