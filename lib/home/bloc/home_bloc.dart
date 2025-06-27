import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:photo_repository/photo_repository.dart';
import 'package:unsplash_app/app/config/config.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required PhotoRepository photoRepository})
    : _photoRepository = photoRepository,
      super(const HomeState()) {
    on<PhotosGet>((event, emit) async => await _photosGet(event, emit));
    on<PhotosSearch>((event, emit) async => await _photosSearch(event, emit));
    on<SearchClear>((event, emit) => _searchClear(event, emit));
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

  Future<void> _photosSearch(PhotosSearch event, Emitter<HomeState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(searchResults: [], searchQuery: '', isSearching: false));
      return;
    }

    emit(state.copyWith(searchStatus: LoadingStatus.loading, searchQuery: event.query, isSearching: true));

    try {
      final searchResults = await _photoRepository.searchPhotos(query: event.query);
      emit(
        state.copyWith(
          searchResults: searchResults,
          searchStatus: LoadingStatus.done,
          searchQuery: event.query,
          isSearching: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(searchStatus: LoadingStatus.error, searchQuery: event.query, isSearching: true));
      if (kDebugMode) {
        print('Search error: $e');
      }
    }
  }

  void _searchClear(SearchClear event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        searchResults: [],
        searchQuery: '',
        isSearching: false,
        searchStatus: LoadingStatus.initial,
      ),
    );
  }
}
