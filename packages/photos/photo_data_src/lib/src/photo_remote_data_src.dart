import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:models/models.dart';
import 'package:photo_data_src/photo_data_src.dart';
import 'package:unsplash_client/unsplash_client.dart';

class PhotoRemoteDataSrc implements PhotoDataSrc {
  late final UnsplashClient _client = UnsplashClient(
    settings: ClientSettings(
      credentials: AppCredentials(accessKey: dotenv.env['TOKEN']!, secretKey: dotenv.env['SECRET']),
    ),
  );

  @override
  Future<List<Item>> getPhotos() async {
    try {
      final photos = await _client.photos.random(count: 8, contentFilter: ContentFilter.high).go();
      return Item.listFromJson(photos.json);
    } catch (e) {
      if (kDebugMode) print('Unsplash fetch error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Item>> searchPhotos({required String query}) async {
    try {
      final results = await _client.search.photos(query).go();

      return Item.listFromJson(results.json['results']);
    } catch (e) {
      if (kDebugMode) print('Unsplash fetch error: $e');
      rethrow;
    }
  }
}
