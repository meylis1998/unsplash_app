import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:unsplash_app/home/view/widgets/photo_detail_sheet.dart';

import '../../../app/config/config.dart';

class PhotoCard extends StatelessWidget {
  final Item photo;
  final VoidCallback onFavoriteToggle;

  const PhotoCard({required this.photo, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotoDetail(photo: photo, onFavoriteToggle: onFavoriteToggle),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo.urls.regular != null)
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(color: Color(int.parse(photo.color.replaceFirst('#', '0xFF')))),
                  child: CachedNetworkImage(
                    imageUrl: photo.urls.regular!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color(int.parse(photo.color.replaceFirst('#', '0xFF'))),
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: AppTheme.grey, size: 32),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
