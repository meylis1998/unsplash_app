import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app/config/config.dart';
import '../bloc/home_bloc.dart';

part 'widgets/empty_state.dart';
part 'widgets/error.dart';
part 'widgets/info_chip.dart';
part 'widgets/link_chip.dart';
part 'widgets/loading.dart';
part 'widgets/photo_card.dart';
part 'widgets/photo_detail_sheet.dart';
part 'widgets/photo_grid.dart';
part 'widgets/search_box.dart';
part 'widgets/stat_chip.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 4),
        actions: [
          IconButton(
            color: Colors.white,
            iconSize: 30,
            icon: const Icon(CupertinoIcons.heart),
            onPressed: () {
              context.read<HomeBloc>().add(const PhotosGet());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case LoadingStatus.loading:
              return const _LoadingWidget();

            case LoadingStatus.done:
              if (state.photos.isEmpty) {
                return const _EmptyStateWidget();
              }
              return _PhotoGridWidget(photos: state.photos);

            case LoadingStatus.error:
              return _ErrorWidget(
                onRetry: () {
                  context.read<HomeBloc>().add(const PhotosGet());
                },
              );

            default:
              return const _LoadingWidget();
          }
        },
      ),
    );
  }
}
