import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({super.key, this.url, this.name});

  final String? name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? 'https://avatars.dicebear.com/v2/initials/${name}.png',
      fit: BoxFit.cover,
    );
  }
}
