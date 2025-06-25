import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:models/models.dart';
import 'package:photo_data_src/photo_data_src.dart';

class PhotoRemoteDataSrc implements PhotoDataSrc {
  final DioClientHandler _dioClientHandler;

  PhotoRemoteDataSrc({required DioClientHandler dioClientHandler})
    : _dioClientHandler = dioClientHandler;

  @override
  Future<List<Item>> getPhotos({required String accessToken}) async {
    try {
      final response = await _dioClientHandler.get(
        path: '/photos/',
        options: Options(headers: {'Authorization': 'Client-ID $accessToken'}),
      );

      return Item.listFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
