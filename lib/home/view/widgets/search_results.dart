part of '../home_view.dart';

class _SearchResultsWidget extends StatelessWidget {
  final List<Item> photos;
  const _SearchResultsWidget({required this.photos});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<Item>>(
      builder: (context, favorites) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverList.separated(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return PhotoCard(
                photo: photo,
                onFavoriteToggle: () {
                  context.read<FavoritesCubit>().toggle(photo);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
        );
      },
    );
  }
}
