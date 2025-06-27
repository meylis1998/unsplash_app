import 'package:models/models.dart';

abstract class PhotoDataSrc {
  Future<List<Item>> getPhotos();

  Future<List<Item>> searchPhotos({required String query});
}
