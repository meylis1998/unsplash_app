import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:models/models.dart';
import 'package:photo_data_src/photo_data_src.dart';

class PhotoRepository {
  final PhotoDataSrc _dataSrc;

  const PhotoRepository({required PhotoDataSrc dataSrc}) : _dataSrc = dataSrc;

  Future<List<Item>> getPhotos() async {
    final key = dotenv.env['TOKEN']!;
    try {
      return _dataSrc.getPhotos(accessToken: key);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
