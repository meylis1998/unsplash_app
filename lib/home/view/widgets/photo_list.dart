part of '../home_view.dart';

class _PhotoListWidget extends StatelessWidget {
  final List<Item> photos;
  const _PhotoListWidget({required this.photos});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<Item>>(
      builder: (context, favorites) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const PhotosGet());
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SearchBoxWidget()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverPadding(
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
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ),
        );
      },
    );
  }
}
