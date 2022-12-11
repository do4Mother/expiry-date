import 'package:expiry/views/home/bloc/market/market_bloc.dart';
import 'package:expiry/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<MarketBloc>().state;
    return state.builder(
      error: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sorry, something wrong',
            style: textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      loaded: Visibility(
        visible: state.data?.isNotEmpty ?? false,
        replacement: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sorry, There are no items yet.',
              style: textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Text(
              'You can sell your item by enable selling item under create/update section.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        child: ListView.builder(
          padding: kPaddingListView,
          itemCount: state.data?.length ?? 0,
          itemBuilder: (context, index) {
            final item = state.data?[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 1,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 110,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: AppImage(
                            url: item?.photo,
                            name: item?.name,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item?.name ?? '',
                              style: textTheme.headline6,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Exp ${DateFormat('dd MMM yyyy').format(item?.expDate ?? DateTime.now())}',
                              style: textTheme.bodySmall,
                            ),
                            const Spacer(),
                            Text(
                              'Rp ${item?.price ?? 0}',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
