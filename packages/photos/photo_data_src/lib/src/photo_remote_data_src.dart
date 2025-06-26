import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:models/models.dart';
import 'package:photo_data_src/photo_data_src.dart';
import 'package:unsplash_client/unsplash_client.dart';

class PhotoRemoteDataSrc implements PhotoDataSrc {
  @override
  Future<List<Item>> getPhotos() async {
    try {
      final accessKey = dotenv.env['TOKEN']!;
      final secret = dotenv.env['SECRET'];

      final client = UnsplashClient(
        settings: ClientSettings(
          credentials: AppCredentials(accessKey: accessKey, secretKey: secret),
        ),
      );

      final photos = await client.photos.random(count: 8, contentFilter: ContentFilter.high).go();
      return Item.listFromJson(photos.json);
    } catch (e) {
      if (kDebugMode) print('Unsplash fetch error: $e');
      rethrow;
    } finally {}
  }
}
