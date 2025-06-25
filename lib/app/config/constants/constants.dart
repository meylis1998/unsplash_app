// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  // Media Query
  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}
