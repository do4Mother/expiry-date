import 'dart:io';

import 'package:expiry/app/bloc/authentication/authentication_bloc.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/utils/constant.dart';
import 'package:expiry/views/product/add_product/cubit/crud_product/crud_product_cubit.dart';
import 'package:expiry/widgets/date_picker.dart';
import 'package:expiry/widgets/field_dropdown.dart';
import 'package:expiry/widgets/image_picker.dart';
import 'package:expiry/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expiry/utils/extension.dart';

class AddProductView extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormBuilderState>();
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

  onSave() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic> data = Map.from(_formKey.currentState?.value ?? {});
      data.addAll({'id': ''});
      final product = Product.fromJson(data);
      final profile = context.read<AuthenticationBloc>().state.data;

      context.read<CRUDProductCubit>().addProduct(
            product: product.copyWith(profile: profile, isSale: isSell),
            file: image,
          );
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
                  name: 'exp_date',
                  title: 'Expiry',
                  validators: [FormBuilderValidators.required()],
                ),
                AppFieldDropdown(
                  name: 'priority',
                  title: 'Priority',
                  info: 'Low: artinya aku sayang nabella\nMedium: artinya juga sayang bella\nHigh: sayang banget nabella xixixixi',
                  items: ProductPriority.values
                      .map((e) => DropdownMenuItem(
                            value: e.name,
                            child: Text(e.name.toCapitalized()),
                          ))
                      .toList(),
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
                    children: [
                      kVerticalMediumBox,
                      const AppTextField(
                        name: 'descriptions',
                        title: 'Descriptions',
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                      AppTextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        name: 'price',
                        title: 'Price',
                        valueTransformer: (value) => double.tryParse(value ?? '0'),
                      ),
                    ],
                  ),
                ),
                kVerticalGiantBox,
                BlocConsumer<CRUDProductCubit, StateHelper<Product>>(
                  listener: (context, state) {
                    state.listener(
                      error: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      },
                      loaded: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == Status.loading ? null : onSave,
                      child: const Text('Save'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
