import 'dart:io';

import 'package:expiry/utils/constant.dart';
import 'package:expiry/widgets/date_picker.dart';
import 'package:expiry/widgets/field_dropdown.dart';
import 'package:expiry/widgets/image_picker.dart';
import 'package:expiry/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';

class AddProductView extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  bool isSell = false;
  File? image;

  pickImage() async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return const AppImagePicker();
      },
    );

    if (result is XFile) {
      setState(() {
        image = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: kPaddingListView,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add item',
                  style: textTheme.headline4,
                ),
                kVerticalMediumBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: image == null
                            ? MaterialButton(
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: pickImage,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : GestureDetector(
                                onTap: pickImage,
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                kVerticalHugeBox,
                AppTextField(
                  name: 'name',
                  title: 'Name',
                  validators: [FormBuilderValidators.required()],
                ),
                AppDatePicker(
                  name: 'expiry',
                  title: 'Expiry',
                  validators: [FormBuilderValidators.required()],
                ),
                const AppFieldDropdown(
                  name: 'priority',
                  title: 'Priority',
                  info: 'Low: artinya aku sayang nabella\nMedium: artinya juga sayang bella\nHigh: sayang banget nabella xixixixi',
                  items: [
                    DropdownMenuItem(
                      value: 'low',
                      child: Text('Low'),
                    ),
                    DropdownMenuItem(
                      value: 'medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'high',
                      child: Text('High'),
                    ),
                  ],
                ),
                const AppTextField(
                  name: 'place_detail',
                  title: 'Place Detail',
                  info: 'Maybe you forgot where is the item placed',
                  minLines: 2,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Want to sell it?',
                        style: textTheme.headline4,
                      ),
                    ),
                    Switch.adaptive(
                      value: isSell,
                      onChanged: (value) {
                        setState(() {
                          isSell = value;
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: isSell,
                  child: Column(
                    children: const [
                      kVerticalMediumBox,
                      AppTextField(
                        name: 'descriptions',
                        title: 'Descriptions',
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                      AppTextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        name: 'price',
                        title: 'Price',
                      ),
                    ],
                  ),
                ),
                kVerticalGiantBox,
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
