import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/constant.dart';

class AppProduct extends StatelessWidget {
  const AppProduct({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => context.push('/product/abcs'),
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
                    child: Image.network(
                      'https://akcdn.detik.net.id/community/media/visual/2022/11/01/keistimewaan-botol-minum-corkcicle-yang-viral-diburu-orang-kantoran_43.jpeg?w=250&q=',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
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
                )
              ],
            ),
            kVerticalTinyBox,
            const Text('Botol Kecap'),
            const SizedBox(
              height: 2,
            ),
            Text(
              '17 Dec 2022',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
