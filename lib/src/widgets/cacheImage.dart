import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;

  const CacheImage(this.imageUrl, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Image.asset(
          'assets/images/placeholder.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
