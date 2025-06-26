import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:photo_repository/photo_repository.dart';
import 'package:unsplash_app/app/config/config.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required PhotoRepository photoRepository}) : _photoRepository = photoRepository, super(const HomeState()) {
    on<PhotosGet>((event, emit) async => await _photosGet(event, emit));

    add(PhotosGet());
  }

  final PhotoRepository _photoRepository;

  Future<void> _photosGet(PhotosGet event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final photos = await _photoRepository.getPhotos();

      emit(state.copyWith(photos: photos, status: LoadingStatus.done));
    } catch (e) {
      emit(state.copyWith(status: LoadingStatus.error));
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
