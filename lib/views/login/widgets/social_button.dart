import 'package:flutter/material.dart';

import '../../../utils/constant.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.name,
    required this.onPressed,
    required this.image,
  });

  final String name;
  final Function() onPressed;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500.withOpacity(0.8),
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              child: image,
            ),
            kHorizontalSmallBox,
            Text(
              'Continue with $name',
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
