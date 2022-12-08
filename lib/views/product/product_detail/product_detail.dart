import 'package:expiry/utils/constant.dart';
import 'package:expiry/views/product/product_detail/cubit/cubit/product_detail_cubit.dart';
import 'package:expiry/views/product/product_detail/widgets/info_tile.dart';
import 'package:expiry/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:expiry/utils/extension.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  static const String routeName = '/product/:id';

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is ProductDetailLoaded) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Hero(
                            tag: state.product?.id ?? '',
                            child: AppImage(
                              name: state.product?.name,
                              url: state.product?.photo,
                            ),
                          ),
                        ),
                        kVerticalMediumBox,
                        Padding(
                          padding: kPaddingItemView,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Details',
                                style: textTheme.headline4,
                              ),
                              kVerticalTinyBox,
                              InfoTile(
                                title: 'Title',
                                subtitle: state.product?.name ?? '',
                                useColumn: true,
                              ),
                              InfoTile(
                                title: 'Expiry Date',
                                subtitle: DateFormat('dd MMMM yyyy').format(state.product?.expDate ?? DateTime.now()),
                              ),
                              InfoTile(
                                title: 'Priority',
                                subtitle: (state.product?.priority.name ?? '').toCapitalized(),
                              ),
                              InfoTile(
                                title: 'Place Detail',
                                subtitle: state.product?.placeDetail ?? '',
                                hideBorder: true,
                              ),
                              kVerticalLargeBox,
                              Text(
                                'Sale Details',
                                style: textTheme.headline4,
                              ),
                              kVerticalTinyBox,
                              const InfoTile(
                                title: 'Descriptions',
                                subtitle: 'Lorem ipsum dolor sit amet',
                                useColumn: true,
                              ),
                              const InfoTile(title: 'Price', subtitle: 'Rp. 2000', hideBorder: true),
                              kVerticalGiantBox,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0, -0.5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(onPressed: () {}, child: const Text('Purchase')),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
