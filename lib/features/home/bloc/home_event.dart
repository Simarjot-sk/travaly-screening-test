part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialDataRequested extends HomeEvent {}

class HomeErrorConsumed extends HomeEvent {}
