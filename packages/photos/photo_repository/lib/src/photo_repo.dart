import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:photo_data_src/photo_data_src.dart';

class PhotoRepository {
  final PhotoDataSrc _dataSrc;

  const PhotoRepository({required PhotoDataSrc dataSrc}) : _dataSrc = dataSrc;

  Future<List<Item>> getPhotos() async {
    try {
      return _dataSrc.getPhotos();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
