import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/product/cubit/product/product_cubit.dart';
import 'package:expiry/views/product/product_detail/widgets/info_tile.dart';
import 'package:expiry/widgets/error.dart';
import 'package:expiry/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:expiry/utils/extension.dart';

import '../../../models/product.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  static const String routeName = '/product/:id';

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<ProductCubit, StateHelper<Product>>(
          builder: (context, state) {
            return state.builder(
              loaded: Visibility(
                visible: state.data != null,
                replacement: const AppError(
                  title: 'Sorry, it looks like what you\'re looking for doesn\'t exist',
                ),
                child: _buildBody(state.data),
              ),
              error: AppError(
                title: 'Sorry, it looks like what you\'re looking for doesn\'t exist',
                subtitle: state.message,
              ),
            );
          },
        ),
      ),
    );
  }

  _buildBody(Product? product) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.4,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: product?.id ?? '',
                  child: AppImage(
                    name: product?.name,
                    url: product?.photo,
                  ),
                ),
              ),
            ),
          ),
          kVerticalMediumBox,
          Padding(
            padding: kPaddingItemView,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Details',
                  style: textTheme.headline4,
                ),
                kVerticalTinyBox,
                InfoTile(
                  title: 'Title',
                  subtitle: product?.name ?? '',
                  useColumn: true,
                ),
                InfoTile(
                  title: 'Expiry Date',
                  subtitle: DateFormat('dd MMMM yyyy').format(product?.expDate ?? DateTime.now()),
                ),
                InfoTile(
                  title: 'Priority',
                  subtitle: (product?.priority.name ?? '').toCapitalized(),
                ),
                InfoTile(
                  title: 'Place Detail',
                  subtitle: product?.placeDetail ?? '',
                  hideBorder: true,
                ),
                Visibility(
                  visible: product?.isSale ?? false,
                  child: _buildSaleInfo(product),
                ),
                kVerticalGiantBox,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                    kHorizontalMediumBox,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/edit-product/${product?.id}'),
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildSaleInfo(Product? product) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kVerticalLargeBox,
        Text(
          'Sale Details',
          style: textTheme.headline4,
        ),
        kVerticalTinyBox,
        InfoTile(
          title: 'Descriptions',
          subtitle: product?.descriptions ?? '',
          useColumn: true,
        ),
        InfoTile(title: 'Price', subtitle: 'Rp. ${product?.price ?? 0}', hideBorder: true),
      ],
    );
  }
}
