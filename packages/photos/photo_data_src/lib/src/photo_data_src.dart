import 'package:models/models.dart';

abstract class PhotoDataSrc {
  Future<List<Item>> getPhotos({required String accessToken});
}
