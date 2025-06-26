import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unsplash_app/app/config/config.dart';

class PhotoScreen extends StatelessWidget {
  final String image;
  const PhotoScreen(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    final double paddingTop = View.of(context).padding.top;
    return Container(
      color: AppTheme.black,
      child: Stack(
        children: <Widget>[
          PhotoView(
            loadingBuilder: (_, chunk) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            imageProvider: CachedNetworkImageProvider(image),
          ),
          OrientationBuilder(
            builder: (cntxt, orientation) {
              double height =
                  (orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width) *
                  0.049;
              return Container(
                height: height,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.98,
                margin: EdgeInsets.only(top: paddingTop),
                child: FittedBox(
                  child: Material(
                    color: AppTheme.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(cntxt).pop(),
                      child: Icon(Icons.close, color: AppTheme.white, size: height * 0.8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
