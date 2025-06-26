part of '../home_view.dart';

class _PhotoGridWidget extends StatelessWidget {
  final List<Item> photos;

  const _PhotoGridWidget({required this.photos});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const PhotosGet());
      },
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 20),
        padding: const EdgeInsets.all(8.0),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return _PhotoCard(photo: photo);
        },
      ),
    );
  }
}
