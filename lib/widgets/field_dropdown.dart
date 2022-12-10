import 'package:expiry/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'info_tooltip.dart';

class AppFieldDropdown<T> extends StatelessWidget {
  final String name;
  final String title;
  final String? info;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final dynamic Function(T?)? valueTransformer;

  const AppFieldDropdown({
    super.key,
    required this.name,
    required this.title,
    required this.items,
    this.info,
    this.initialValue,
    this.valueTransformer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title),
            kHorizontalTinyBox,
            Visibility(
              visible: info?.isNotEmpty ?? false,
              child: InfoTooltip(
                message: info ?? '',
              ),
            ),
          ],
        ),
        kVerticalTinyBox,
        FormBuilderDropdown<T>(
          name: name,
          initialValue: initialValue,
          decoration: InputDecoration(hintText: title),
          items: items,
          valueTransformer: valueTransformer,
        ),
        kVerticalLargeBox,
      ],
    );
  }
}
