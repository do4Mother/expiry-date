import 'package:expiry/models/product.dart';
import 'package:expiry/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../utils/constant.dart';

class AppProduct extends StatelessWidget {
  const AppProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: product.id,
                      child: AppImage(
                        url: product.photo,
                        name: product.name,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: product.isSale,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'SALE',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            kVerticalTinyBox,
            Text(product.name),
            const SizedBox(
              height: 2,
            ),
            Text(
              DateFormat('dd MMM yyyy').format(product.expDate),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
