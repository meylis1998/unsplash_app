import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:unsplash_app/favorites/cubit/favorites_cubit.dart';

import '../../app/config/config.dart';
import '../bloc/home_bloc.dart';
import 'widgets/photo_card.dart';
import 'widgets/photo_detail_sheet.dart';

part 'widgets/empty_state.dart';
part 'widgets/error.dart';
part 'widgets/loading.dart';
part 'widgets/photo_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        toolbarHeight: 80.h,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 3),
        actions: [
          IconButton(
            color: AppTheme.white,
            iconSize: 30.sp,
            icon: const Icon(CupertinoIcons.heart),
            onPressed: () {
              context.push(AppRoutes.favorites);
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
              return _PhotoListWidget(photos: state.photos);

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
