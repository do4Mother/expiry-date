import 'package:expiry/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AppDatePicker extends StatelessWidget {
  final String name;
  final String title;
  final int? minLines;
  final int? maxLines;
  final List<FormFieldValidator>? validators;

  const AppDatePicker({
    super.key,
    required this.name,
    required this.title,
    this.minLines,
    this.maxLines,
    this.validators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        kVerticalTinyBox,
        FormBuilderDateTimePicker(
          name: name,
          inputType: InputType.date,
          validator: FormBuilderValidators.compose(validators ?? []),
          decoration: InputDecoration(
            hintText: title,
          ),
        ),
        kVerticalLargeBox,
      ],
    );
  }
}
