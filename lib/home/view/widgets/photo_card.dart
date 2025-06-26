part of '../home_view.dart';

class _PhotoCard extends StatelessWidget {
  final Item photo;

  const _PhotoCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => _showPhotoDetails(context, photo),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo.urls.regular != null)
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(photo.color.replaceFirst('#', '0xFF')),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: photo.urls.regular!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color(
                        int.parse(photo.color.replaceFirst('#', '0xFF')),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDetails(BuildContext context, Item photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PhotoDetailsSheet(photo: photo),
    );
  }
}
