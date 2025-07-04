import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:models/models.dart';
import 'package:unsplash_app/favorites/cubit/favorites_cubit.dart';
import 'package:unsplash_app/home/view/widgets/photo.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app/config/config.dart';
import '../bloc/home_bloc.dart';

part 'widgets/info_chip.dart';
part 'widgets/link_chip.dart';
part 'widgets/search_box.dart';
part 'widgets/stat_chip.dart';

class PhotoDetail extends StatefulWidget {
  final Item photo;

  final VoidCallback onFavoriteToggle;

  const PhotoDetail({Key? key, required this.photo, required this.onFavoriteToggle}) : super(key: key);

  @override
  State<PhotoDetail> createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.black,
        toolbarHeight: 80.h,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image
              _buildMainImage(item: widget.photo),
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
              if (widget.photo.color.isNotEmpty || widget.photo.blurHash.isNotEmpty) _buildColorSection(),

              const SizedBox(height: 16),
              // Alternative slugs
              if (_hasAlternativeSlugs()) _buildAlternativeSlugSection(),

              const SizedBox(height: 16),
              // Topics
              if (widget.photo.topicSubmissions.isNotEmpty) _buildTopicsSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainImage({required Item item}) {
    return Stack(
      children: [
        widget.photo.urls.regular != null
            ? GestureDetector(
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => PhotoScreen(widget.photo.urls.regular!))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.photo.urls.regular!,
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
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: AppTheme.transparent,
            child: BlocBuilder<FavoritesCubit, List<Item>>(
              builder: (context, favorites) {
                final isFavorite = favorites.any((c) => c.id == widget.photo.id);

                return IconButton(
                  icon: Icon(
                    isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isFavorite ? AppTheme.red : AppTheme.white,
                  ),
                  onPressed: widget.onFavoriteToggle,
                  iconSize: 32,
                  splashRadius: 24,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.photo.description != null && widget.photo.description!.isNotEmpty)
          Text(
            widget.photo.description!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        if (widget.photo.description != null && widget.photo.description!.isNotEmpty)
          const SizedBox(height: 8),
        Text(
          widget.photo.altDescription,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.grey[600], height: 1.4),
        ),
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
          Text(
            'Photographer',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: widget.photo.user.profileImage?.medium != null
                    ? CachedNetworkImageProvider(widget.photo.user.profileImage!.medium!)
                    : null,
                child: widget.photo.user.profileImage?.medium == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.photo.user.name ?? 'Unknown',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (widget.photo.user.username != null)
                      Text(
                        '@${widget.photo.user.username}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Colors.grey[600]),
                      ),
                    if (widget.photo.user.location != null)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.photo.user.location!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.photo.user.bio != null && widget.photo.user.bio!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.photo.user.bio!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Colors.grey[700], height: 1.4),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.photo.user.totalPhotos != null)
                _InfoChip(
                  icon: Icons.photo_camera,
                  label: '${widget.photo.user.totalPhotos} photos',
                  context: context,
                ),
              if (widget.photo.user.totalLikes != null)
                _InfoChip(
                  icon: Icons.favorite_border,
                  label: '${widget.photo.user.totalLikes} likes',
                  context: context,
                ),
              if (widget.photo.user.totalCollections != null)
                _InfoChip(
                  icon: Icons.collections,
                  label: '${widget.photo.user.totalCollections} collections',
                  context: context,
                ),
              if (widget.photo.user.forHire == true)
                _InfoChip(
                  icon: Icons.work,
                  label: 'Available for hire',
                  color: AppTheme.green,
                  context: context,
                ),
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
          Text(
            'Photo Stats',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(
                icon: Icons.favorite,
                label: '${widget.photo.likes} likes',
                color: AppTheme.red,
                context: context,
              ),
              _StatChip(
                icon: Icons.photo_size_select_actual,
                label: '${widget.photo.width} × ${widget.photo.height}',
                color: AppTheme.blue,
                context: context,
              ),
              if (widget.photo.likedByUser)
                _StatChip(icon: Icons.favorite, label: 'Liked by you', color: Colors.pink, context: context),
              _StatChip(
                icon: Icons.category,
                label: widget.photo.assetType,
                color: Colors.purple,
                context: context,
              ),
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
          Text(
            'Technical Details',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _DetailRow('ID', widget.photo.id, copyable: true),
          _DetailRow('Slug', widget.photo.slug, copyable: true),
          _DetailRow('Dimensions', '${widget.photo.width} × ${widget.photo.height} pixels'),
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
          Text(
            'Timeline',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _DetailRow('Created', _formatDate(widget.photo.createdAt)),
          _DetailRow('Updated', _formatDate(widget.photo.updatedAt)),
          if (widget.photo.user.updatedAt != null)
            _DetailRow('User Updated', _formatDate(widget.photo.user.updatedAt!)),
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
          Text(
            'Links & Downloads',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.photo.links.html != null)
                _LinkChip(
                  icon: Icons.open_in_browser,
                  label: 'View on Unsplash',
                  url: widget.photo.links.html!,
                  context: context,
                ),
              if (widget.photo.links.download != null)
                _LinkChip(
                  icon: Icons.download,
                  label: 'Download',
                  url: widget.photo.links.download!,
                  context: context,
                ),
              if (widget.photo.user.links?.html != null)
                _LinkChip(
                  icon: Icons.person,
                  label: 'Photographer Profile',
                  url: widget.photo.user.links!.html!,
                  context: context,
                ),
              if (widget.photo.user.portfolioUrl != null)
                _LinkChip(
                  icon: Icons.web,
                  label: 'Portfolio',
                  url: widget.photo.user.portfolioUrl!,
                  context: context,
                ),
              if (widget.photo.user.instagramUsername != null)
                _LinkChip(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  url: 'https://instagram.com/${widget.photo.user.instagramUsername}',
                  context: context,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Image Sizes',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.photo.urls.thumb != null)
                _LinkChip(
                  icon: Icons.image,
                  label: 'Thumbnail',
                  url: widget.photo.urls.thumb!,
                  context: context,
                ),
              if (widget.photo.urls.small != null)
                _LinkChip(icon: Icons.image, label: 'Small', url: widget.photo.urls.small!, context: context),
              if (widget.photo.urls.regular != null)
                _LinkChip(
                  icon: Icons.image,
                  label: 'Regular',
                  url: widget.photo.urls.regular!,
                  context: context,
                ),
              if (widget.photo.urls.full != null)
                _LinkChip(icon: Icons.image, label: 'Full', url: widget.photo.urls.full!, context: context),
              if (widget.photo.urls.raw != null)
                _LinkChip(icon: Icons.image, label: 'Raw', url: widget.photo.urls.raw!, context: context),
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
          Text(
            'Visual Properties',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (widget.photo.color.isNotEmpty)
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _parseColor(widget.photo.color),
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Dominant Color: ${widget.photo.color}'),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () => _copyToClipboard(widget.photo.color),
                ),
              ],
            ),
          if (widget.photo.blurHash.isNotEmpty)
            _DetailRow('Blur Hash', widget.photo.blurHash, copyable: true),
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
          Text(
            'Alternative Slugs',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...(_getAlternativeSlugs().map(
            (entry) => _DetailRow(entry.key.toUpperCase(), entry.value, copyable: true),
          )),
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
          Text(
            'Topics',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.photo.topicSubmissions.keys
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
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
    final gcd = _gcd(widget.photo.width, widget.photo.height);
    return '${widget.photo.width ~/ gcd}:${widget.photo.height ~/ gcd}';
  }

  String _calculateMegapixels() {
    final mp = (widget.photo.width * widget.photo.height) / 1000000;
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
    final slugs = widget.photo.alternativeSlugs;
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
    final alt = widget.photo.alternativeSlugs;

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
