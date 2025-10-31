import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:travaly/data/model/property_dto.dart';
import 'package:travaly/data/repo/travaly_repo.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TravalyRepo _travalyRepo;

  HomeBloc({required TravalyRepo travalyRepo})
    : _travalyRepo = travalyRepo,
      super(HomeState()) {
    on<HomeEvent>(_initialDataRequested);
  }

  void _initialDataRequested(HomeEvent event, Emitter<HomeState> emit) async {
    final tokenAquired = await _travalyRepo.getVisitorToken();
    if (!tokenAquired) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error while fetching visitor token',
        ),
      );
      return;
    }

    final hotels = await _travalyRepo.getHotelList();
    if (hotels == null) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error while fetching hotels',
        ),
      );
      return;
    }
    
    emit(
      state.copyWith(
        isLoading: false,
        hotels: hotels,
      ),
    );
  }
}
