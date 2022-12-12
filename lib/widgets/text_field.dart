import 'package:expiry/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'info_tooltip.dart';

class AppTextField extends StatelessWidget {
  final String name;
  final String title;
  final int? minLines;
  final int? maxLines;
  final String? info;
  final String? initialValue;
  final List<FormFieldValidator<String>>? validators;
  final TextInputType? keyboardType;
  final dynamic Function(String?)? valueTransformer;

  const AppTextField({
    super.key,
    required this.name,
    required this.title,
    this.minLines,
    this.maxLines,
    this.validators,
    this.keyboardType,
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
        FormBuilderTextField(
          name: name,
          initialValue: initialValue,
          decoration: InputDecoration(hintText: title),
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: FormBuilderValidators.compose(validators ?? []),
          valueTransformer: valueTransformer,
        ),
        kVerticalLargeBox,
      ],
    );
  }
}
