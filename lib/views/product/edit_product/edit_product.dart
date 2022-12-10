import 'dart:io';

import 'package:expiry/app/bloc/authentication/authentication_bloc.dart';
import 'package:expiry/models/product.dart';
import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/extension.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/product/add_product/cubit/crud_product/crud_product_cubit.dart';
import 'package:expiry/widgets/date_picker.dart';
import 'package:expiry/widgets/error.dart';
import 'package:expiry/widgets/field_dropdown.dart';
import 'package:expiry/widgets/image.dart';
import 'package:expiry/widgets/image_picker.dart';
import 'package:expiry/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({super.key});

  static const String routeName = '/edit-product/:id';

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
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
      final oldProduct = context.read<CRUDProductCubit>().state.data;
      data.addAll({'id': oldProduct?.id});
      final product = Product.fromJson(data);
      final profile = context.read<AuthenticationBloc>().state.data;

      context.read<CRUDProductCubit>().updateProduct(
            product: product.copyWith(
              createdAt: oldProduct?.createdAt,
              updatedAt: oldProduct?.updatedAt,
              profile: profile,
              isSale: isSell,
            ),
            file: image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<CRUDProductCubit, StateHelper<Product>>(
          listener: (context, state) {
            state.listener(loaded: () {
              setState(() {
                isSell = state.data?.isSale ?? false;
              });
            });
          },
          buildWhen: (previous, current) {
            return current.status == Status.loaded;
          },
          builder: (context, state) {
            return state.builder(
              loading: const SizedBox(),
              loaded: _buildBody(state.data),
              error: AppError(
                title: 'Something wrong',
                subtitle: state.message,
              ),
            );
          },
        ),
      ),
    );
  }

  _buildBody(Product? product) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: kPaddingListView,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update item',
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
                    child: image == null && (product?.photo?.isEmpty ?? true)
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
                            child: image == null
                                ? AppImage(
                                    url: product?.photo,
                                  )
                                : Image.file(
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
              initialValue: product?.name,
              name: 'name',
              title: 'Name',
              validators: [FormBuilderValidators.required()],
            ),
            AppDatePicker(
              initialValue: product?.expDate,
              name: 'exp_date',
              title: 'Expiry',
              validators: [FormBuilderValidators.required()],
            ),
            AppFieldDropdown<String>(
              initialValue: product?.priority.name,
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
            AppTextField(
              initialValue: product?.placeDetail,
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
                  AppTextField(
                    initialValue: product?.descriptions,
                    name: 'descriptions',
                    title: 'Descriptions',
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  AppTextField(
                    initialValue: (product?.price ?? '').toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    name: 'price',
                    title: 'Price',
                    valueTransformer: (value) => value?.isNotEmpty ?? false ? double.tryParse(value ?? '0') : 0,
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
    );
  }
}
