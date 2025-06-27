part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class PhotosGet extends HomeEvent {
  const PhotosGet();
}

class PhotosSearch extends HomeEvent {
  final String query;

  const PhotosSearch(this.query);

  @override
  List<Object> get props => [query];
}

class SearchClear extends HomeEvent {
  const SearchClear();
}
