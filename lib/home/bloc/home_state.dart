part of 'home_bloc.dart';

class HomeState extends Equatable {
  final LoadingStatus status;
  final List<Item> photos;

  const HomeState({
    this.status = LoadingStatus.initial,
    this.photos = const [],
  });

  HomeState copyWith({LoadingStatus? status, List<Item>? photos}) {
    return HomeState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
    );
  }

  @override
  List<Object> get props => [status, photos];
}
