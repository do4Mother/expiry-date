import 'package:expiry/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'info_tooltip.dart';

class AppTextField extends StatefulWidget {
  final String name;
  final String title;
  final int? minLines;
  final int? maxLines;
  final String? info;
  final String? initialValue;
  final bool? obscureText;
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
    this.obscureText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool secureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.title),
            kHorizontalTinyBox,
            Visibility(
              visible: widget.info?.isNotEmpty ?? false,
              child: InfoTooltip(
                message: widget.info ?? '',
              ),
            ),
          ],
        ),
        kVerticalTinyBox,
        FormBuilderTextField(
          name: widget.name,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            hintText: widget.title,
            suffixIcon: widget.obscureText ?? false
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        secureText = !secureText;
                      });
                    },
                    icon: Icon(secureText ? Icons.visibility_off : Icons.visibility_rounded),
                  )
                : null,
          ),
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? 1,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          validator: FormBuilderValidators.compose(widget.validators ?? []),
          valueTransformer: widget.valueTransformer,
          obscureText: (widget.obscureText ?? false) ? secureText : false,
        ),
        kVerticalLargeBox,
      ],
    );
  }
}
