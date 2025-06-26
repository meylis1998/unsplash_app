part of '../home_view.dart';

class _PhotoDetailsSheet extends StatelessWidget {
  final Item photo;

  const _PhotoDetailsSheet({required this.photo});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      photo.urls.regular != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: photo.urls.regular!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 16),
                      photo.description != null
                          ? Text(
                              photo.description!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 8),
                      Text(
                        photo.altDescription,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      photo.user.profileImage!.medium != null &&
                              photo.user.username != null
                          ? Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    photo.user.profileImage!.medium!,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        photo.user.name!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '@${photo.user.username}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatChip(
                            icon: Icons.favorite,
                            label: '${photo.likes} likes',
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            icon: Icons.photo,
                            label: '${photo.width} × ${photo.height}',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      if (photo.user.bio != null)
                        if (photo.user.bio!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'About the photographer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            photo.user.bio!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
