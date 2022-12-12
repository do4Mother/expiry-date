import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/product/cubit/product/product_cubit.dart';
import 'package:expiry/views/product/product_detail/widgets/info_tile.dart';
import 'package:expiry/widgets/avatar.dart';
import 'package:expiry/widgets/error.dart';
import 'package:expiry/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../models/product.dart';

class ProductSellView extends StatefulWidget {
  const ProductSellView({super.key});

  static const String routeName = '/product-sell/:id';

  @override
  State<ProductSellView> createState() => _ProductSellViewState();
}

class _ProductSellViewState extends State<ProductSellView> {
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
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
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
                        product?.name ?? '',
                        style: textTheme.headline5,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        product?.descriptions ?? '',
                        style: textTheme.bodyMedium,
                      ),
                      kVerticalTinyBox,
                      InfoTile(
                        title: 'Expiry Date',
                        subtitle: DateFormat('dd MMMM yyyy').format(product?.expDate ?? DateTime.now()),
                      ),
                      InfoTile(title: 'Price', subtitle: 'Rp. ${product?.price ?? 0}'),
                      kVerticalMediumBox,
                      Row(
                        children: [
                          const AppAvatar(url: ''),
                          kHorizontalTinyBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anonymous',
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                'Joined ${DateFormat('dd MMM yyyy').format(product?.profile?.createdAt ?? DateTime.now())}',
                                style: textTheme.bodySmall,
                              )
                            ],
                          )
                        ],
                      ),
                      kVerticalGiantBox,
                      kVerticalGiantBox,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, -4),
                  blurRadius: 14,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_rounded),
                  label: const Text('Chat'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
