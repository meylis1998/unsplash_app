part of 'home_bloc.dart';

class HomeState extends Equatable {
  final LoadingStatus status;
  final List<Item> photos;
  final LoadingStatus searchStatus;
  final List<Item> searchResults;
  final String searchQuery;
  final bool isSearching;

  const HomeState({
    this.status = LoadingStatus.initial,
    this.photos = const [],
    this.searchStatus = LoadingStatus.initial,
    this.searchResults = const [],
    this.searchQuery = '',
    this.isSearching = false,
  });

  HomeState copyWith({
    LoadingStatus? status,
    List<Item>? photos,
    LoadingStatus? searchStatus,
    List<Item>? searchResults,
    String? searchQuery,
    bool? isSearching,
  }) {
    return HomeState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      searchStatus: searchStatus ?? this.searchStatus,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [status, photos, searchStatus, searchResults, searchQuery, isSearching];
}
