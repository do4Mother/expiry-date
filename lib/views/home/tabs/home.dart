import 'package:expiry/models/product.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/home/bloc/market/market_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constant.dart';
import '../../../widgets/product.dart';
import '../../product/add_product/add_product.dart';
import '../bloc/list_product/list_product_bloc.dart';
import '../widgets/no_items.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productState = context.watch<ListProductBloc>().state;
    return BlocListener<ListProductBloc, StateHelper<List<Product>>>(
      listener: (context, state) {
        state.listener(loaded: () {
          context.read<MarketBloc>().add(GetMarketProduct());
        });
      },
      child: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: productState.builder(
                    loaded: Visibility(
                      visible: productState.data?.isNotEmpty ?? false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kVerticalMediumBox,
                          Padding(
                            padding: kPaddingItemView,
                            child: Text(
                              'List of items',
                              style: textTheme.headline4,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: productState.builder(
              loaded: Visibility(
                visible: productState.data?.isNotEmpty ?? false,
                replacement: const NoItems(),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 8 / 11,
                    crossAxisSpacing: 8,
                  ),
                  padding: kPaddingListView,
                  itemCount: productState.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return AppProduct(
                      product: productState.data![index],
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight.add(const Alignment(-0.1, -0.05)),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => context.push(AddProductView.routeName),
            ),
          ),
        ],
      ),
    );
  }
}
