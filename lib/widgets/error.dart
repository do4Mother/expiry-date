import 'package:expiry/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, this.title, this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: kPaddingItemView,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle ?? '',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
