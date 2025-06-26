part of '../home_view.dart';

class _PhotoDetailsSheet extends StatelessWidget {
  final Item photo;

  const _PhotoDetailsSheet({Key? key, required this.photo}) : super(key: key);

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
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main image
                      _buildMainImage(),
                      const SizedBox(height: 16),

                      // Title and description
                      _buildTitleSection(),
                      const SizedBox(height: 16),

                      // Photographer info
                      _buildPhotographerSection(context),
                      const SizedBox(height: 16),

                      // Stats section
                      _buildStatsSection(),
                      const SizedBox(height: 16),

                      // Technical details
                      _buildTechnicalSection(),
                      const SizedBox(height: 16),

                      // Dates section
                      _buildDatesSection(),
                      const SizedBox(height: 16),

                      // Links section
                      _buildLinksSection(context),

                      const SizedBox(height: 16),

                      // Color and blur hash
                      if (photo.color.isNotEmpty || photo.blurHash.isNotEmpty) _buildColorSection(),

                      const SizedBox(height: 16),
                      // Alternative slugs
                      if (_hasAlternativeSlugs()) _buildAlternativeSlugSection(),

                      const SizedBox(height: 16),
                      // Topics
                      if (photo.topicSubmissions.isNotEmpty) _buildTopicsSection(),

                      const SizedBox(height: 20),
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

  Widget _buildMainImage() {
    return photo.urls.regular != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: photo.urls.regular!,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.error)),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photo.description != null && photo.description!.isNotEmpty)
          Text(photo.description!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        if (photo.description != null && photo.description!.isNotEmpty) const SizedBox(height: 8),
        Text(photo.altDescription, style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4)),
      ],
    );
  }

  Widget _buildPhotographerSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Photographer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: photo.user.profileImage?.medium != null
                    ? CachedNetworkImageProvider(photo.user.profileImage!.medium!)
                    : null,
                child: photo.user.profileImage?.medium == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.user.name ?? 'Unknown',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (photo.user.username != null)
                      Text('@${photo.user.username}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    if (photo.user.location != null)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(photo.user.location!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (photo.user.bio != null && photo.user.bio!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(photo.user.bio!, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (photo.user.totalPhotos != null)
                _InfoChip(icon: Icons.photo_camera, label: '${photo.user.totalPhotos} photos'),
              if (photo.user.totalLikes != null)
                _InfoChip(icon: Icons.favorite_border, label: '${photo.user.totalLikes} likes'),
              if (photo.user.totalCollections != null)
                _InfoChip(icon: Icons.collections, label: '${photo.user.totalCollections} collections'),
              if (photo.user.forHire == true)
                _InfoChip(icon: Icons.work, label: 'Available for hire', color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Photo Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(icon: Icons.favorite, label: '${photo.likes} likes', color: Colors.red),
              _StatChip(
                icon: Icons.photo_size_select_actual,
                label: '${photo.width} × ${photo.height}',
                color: Colors.blue,
              ),
              if (photo.likedByUser) _StatChip(icon: Icons.favorite, label: 'Liked by you', color: Colors.pink),
              _StatChip(icon: Icons.category, label: photo.assetType, color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Technical Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _DetailRow('ID', photo.id, copyable: true),
          _DetailRow('Slug', photo.slug, copyable: true),
          _DetailRow('Dimensions', '${photo.width} × ${photo.height} pixels'),
          _DetailRow('Aspect Ratio', _calculateAspectRatio()),
          _DetailRow('Megapixels', _calculateMegapixels()),
        ],
      ),
    );
  }

  Widget _buildDatesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _DetailRow('Created', _formatDate(photo.createdAt)),
          _DetailRow('Updated', _formatDate(photo.updatedAt)),
          if (photo.user.updatedAt != null) _DetailRow('User Updated', _formatDate(photo.user.updatedAt!)),
        ],
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Links & Downloads', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (photo.links.html != null)
                _LinkChip(icon: Icons.open_in_browser, label: 'View on Unsplash', url: photo.links.html!),
              if (photo.links.download != null)
                _LinkChip(icon: Icons.download, label: 'Download', url: photo.links.download!),
              if (photo.user.links?.html != null)
                _LinkChip(icon: Icons.person, label: 'Photographer Profile', url: photo.user.links!.html!),
              if (photo.user.portfolioUrl != null)
                _LinkChip(icon: Icons.web, label: 'Portfolio', url: photo.user.portfolioUrl!),
              if (photo.user.instagramUsername != null)
                _LinkChip(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  url: 'https://instagram.com/${photo.user.instagramUsername}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Image Sizes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (photo.urls.thumb != null) _LinkChip(icon: Icons.image, label: 'Thumbnail', url: photo.urls.thumb!),
              if (photo.urls.small != null) _LinkChip(icon: Icons.image, label: 'Small', url: photo.urls.small!),
              if (photo.urls.regular != null) _LinkChip(icon: Icons.image, label: 'Regular', url: photo.urls.regular!),
              if (photo.urls.full != null) _LinkChip(icon: Icons.image, label: 'Full', url: photo.urls.full!),
              if (photo.urls.raw != null) _LinkChip(icon: Icons.image, label: 'Raw', url: photo.urls.raw!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Visual Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          if (photo.color.isNotEmpty)
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _parseColor(photo.color),
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Dominant Color: ${photo.color}'),
                IconButton(icon: const Icon(Icons.copy, size: 16), onPressed: () => _copyToClipboard(photo.color)),
              ],
            ),
          if (photo.blurHash.isNotEmpty) _DetailRow('Blur Hash', photo.blurHash, copyable: true),
        ],
      ),
    );
  }

  Widget _buildAlternativeSlugSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alternative Slugs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...(_getAlternativeSlugs().map((entry) => _DetailRow(entry.key.toUpperCase(), entry.value, copyable: true))),
        ],
      ),
    );
  }

  Widget _buildTopicsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Topics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: photo.topicSubmissions.keys
                .map((topic) => Chip(label: Text(topic), backgroundColor: Colors.teal[100]))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _DetailRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
          if (copyable)
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () => _copyToClipboard(value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _calculateAspectRatio() {
    final gcd = _gcd(photo.width, photo.height);
    return '${photo.width ~/ gcd}:${photo.height ~/ gcd}';
  }

  String _calculateMegapixels() {
    final mp = (photo.width * photo.height) / 1000000;
    return '${mp.toStringAsFixed(1)} MP';
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  bool _hasAlternativeSlugs() {
    final slugs = photo.alternativeSlugs;
    return slugs.en != null ||
        slugs.es != null ||
        slugs.ja != null ||
        slugs.fr != null ||
        slugs.it != null ||
        slugs.ko != null ||
        slugs.de != null ||
        slugs.pt != null;
  }

  List<MapEntry<String, String>> _getAlternativeSlugs() {
    final List<MapEntry<String, String>> slugs = [];
    final alt = photo.alternativeSlugs;

    if (alt.en != null) slugs.add(MapEntry('en', alt.en!));
    if (alt.es != null) slugs.add(MapEntry('es', alt.es!));
    if (alt.ja != null) slugs.add(MapEntry('ja', alt.ja!));
    if (alt.fr != null) slugs.add(MapEntry('fr', alt.fr!));
    if (alt.it != null) slugs.add(MapEntry('it', alt.it!));
    if (alt.ko != null) slugs.add(MapEntry('ko', alt.ko!));
    if (alt.de != null) slugs.add(MapEntry('de', alt.de!));
    if (alt.pt != null) slugs.add(MapEntry('pt', alt.pt!));

    return slugs;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
