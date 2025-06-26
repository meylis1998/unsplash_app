import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/config.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80.h,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 3),
      ),
      body: Center(
        child: Text(
          'Избранное',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 36.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
