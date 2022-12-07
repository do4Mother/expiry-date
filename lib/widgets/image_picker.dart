import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  const AppImagePicker({super.key});

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: kPaddingItemView,
            child: Text(
              'Select image',
              style: textTheme.headline5,
            ),
          ),
          kVerticalSmallBox,
          ListTile(
            onTap: () async {
              try {
                final getImage = await picker.pickImage(source: ImageSource.gallery);
                if (getImage != null && mounted) {
                  Navigator.pop(context, getImage);
                }
              } catch (e) {
                logger.e(e.toString());
              }
            },
            title: const Text('Gallery'),
          ),
          ListTile(
            onTap: () async {
              try {
                final getImage = await picker.pickImage(source: ImageSource.camera);
                if (getImage != null && mounted) {
                  Navigator.pop(context, getImage);
                }
              } catch (e) {
                logger.e(e.toString());
              }
            },
            title: const Text('Camera'),
          ),
        ],
      ),
    );
  }
}
