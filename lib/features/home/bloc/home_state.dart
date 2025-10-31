part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final List<PropertyDto> hotels;

  const HomeState({
    this.isLoading = false,
    this.errorMessage = '',
    this.hotels = const [],
  });

  @override
  List<Object> get props => [isLoading, errorMessage, hotels];

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<PropertyDto>? hotels,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hotels: hotels ?? this.hotels,
    );
  }
}
