import 'package:expiry/utils/constant.dart';
import 'package:expiry/views/product/product_detail/widgets/info_tile.dart';
import 'package:flutter/material.dart';

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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      'https://akcdn.detik.net.id/community/media/visual/2022/11/01/keistimewaan-botol-minum-corkcicle-yang-viral-diburu-orang-kantoran_43.jpeg?w=250&q=',
                      fit: BoxFit.cover,
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
                        const InfoTile(
                          title: 'Title',
                          subtitle: 'Botol Kecap ABDEF',
                          useColumn: true,
                        ),
                        const InfoTile(title: 'Expiry Date', subtitle: '10 Dec 2020'),
                        const InfoTile(title: 'Notify', subtitle: 'Every 1 month'),
                        const InfoTile(
                          title: 'Place Detail',
                          subtitle: 'Dibawah kasur',
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
        ),
      ),
    );
  }
}
