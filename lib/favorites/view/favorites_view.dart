import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:models/models.dart';
import 'package:unsplash_app/favorites/cubit/favorites_cubit.dart';

import '../../app/config/config.dart';
import '../../home/view/widgets/photo_card.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<Item> _items;

  @override
  void initState() {
    super.initState();

    _items = List.from(context.read<FavoritesCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.black,
        toolbarHeight: 80.h,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 3),

        actions: [IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))],
      ),
      body: BlocListener<FavoritesCubit, List<Item>>(
        listener: (context, newList) {
          // handle removals
          for (var oldChar in List<Item>.from(_items)) {
            if (!newList.any((c) => c.id == oldChar.id)) {
              final index = _items.indexWhere((c) => c.id == oldChar.id);
              final removedItem = _items.removeAt(index);
              _listKey.currentState?.removeItem(
                index,
                (ctx, anim) => SizeTransition(
                  sizeFactor: anim,
                  child: PhotoCard(photo: removedItem, onFavoriteToggle: () {}),
                ),
                duration: const Duration(milliseconds: 300),
              );
            }
          }
          // handle insertions
          for (var newChar in newList) {
            if (!_items.any((c) => c.id == newChar.id)) {
              final insertIndex = newList.indexWhere((c) => c.id == newChar.id);
              _items.insert(insertIndex, newChar);
              _listKey.currentState?.insertItem(insertIndex, duration: const Duration(milliseconds: 300));
            }
          }
        },
        child: BlocBuilder<FavoritesCubit, List<Item>>(
          builder: (context, state) {
            _items = List.from(state);
            if (_items.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: Constants.deviceWidth(context) / 3,
                      height: Constants.deviceHeight(context) / 3,
                      child: SvgPicture.asset('assets/icons/favorite.svg'),
                    ),
                  ),
                  Text(
                    'Нет закладок',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 36.sp),
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Избранное',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 36.sp),
                  ),
                  SizedBox(height: 40.h),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 20.h),
                      key: _listKey,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return PhotoCard(
                          photo: item,
                          onFavoriteToggle: () => context.read<FavoritesCubit>().toggle(item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
