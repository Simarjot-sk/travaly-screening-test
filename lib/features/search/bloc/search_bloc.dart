import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:travaly/data/model/property_dto.dart';
import 'package:travaly/data/model/search_autocomplete_item_dto.dart';
import 'package:travaly/data/repo/travaly_repo.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TravalyRepo _travalyRepo;

  SearchBloc({required TravalyRepo travalyRepo})
    : _travalyRepo = travalyRepo,
      super(SearchState(searchQueryController: TextEditingController())) {
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: droppable());
    on<SearchSuggestionClicked>(_onSuggestionClicked);
    on<SearchStartDateSelected>(_onStartDateSelected);
    on<SearchEndDateSelected>(_onEndDateSelected);
    on<SearchAdultIncremented>(_onAdultIncremented);
    on<SearchAdultDecremented>(_onAdultDecremented);
    on<SearchKidIncremented>(_onKidIncremented);
    on<SearchKidDecremented>(_onKidDecremented);
    on<SearchSubmitClicked>(_onSearchSubmitClicked, transformer: droppable());
    on<SearchErrorMessageConsumed>(_onSearchErrorMessageConsumed);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.length < 3) return;
    emit(state.copyWith(isLoading: true));
    final suggestions = await _travalyRepo.getSearchAutoCompleteSuggestions(
      event.query,
    );
    emit(
      state.copyWith(
        autoCompleteItems: () => suggestions ?? [],
        isLoading: false,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onSuggestionClicked(
    SearchSuggestionClicked event,
    Emitter<SearchState> emit,
  ) {
    state.searchQueryController?.text = event.suggestion.itemName;
    emit(
      state.copyWith(
        autoCompleteItems: () => [],
        selectedAutocompleteItem: event.suggestion,
      ),
    );
  }

  void _onStartDateSelected(
    SearchStartDateSelected event,
    Emitter<SearchState> emit,
  ) {
    final formatted = DateFormat('dd MMM, yy').format(event.startDate);
    emit(
      state.copyWith(startDate: event.startDate, startDateFormatted: formatted),
    );
  }

  void _onEndDateSelected(
    SearchEndDateSelected event,
    Emitter<SearchState> emit,
  ) {
    final formatted = DateFormat('dd MMM, yy').format(event.endDate);
    emit(state.copyWith(endDate: event.endDate, endDateFormatted: formatted));
  }

  void _onAdultIncremented(
    SearchAdultIncremented event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(adultCount: state.adultCount + 1));
  }

  void _onAdultDecremented(
    SearchAdultDecremented event,
    Emitter<SearchState> emit,
  ) {
    if (state.adultCount < 2) return;
    emit(state.copyWith(adultCount: state.adultCount - 1));
  }

  void _onKidIncremented(
    SearchKidIncremented event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(kidCount: state.kidCount + 1));
  }

  void _onKidDecremented(
    SearchKidDecremented event,
    Emitter<SearchState> emit,
  ) {
    if (state.kidCount < 1) return;
    emit(state.copyWith(kidCount: state.kidCount - 1));
  }

  void _onSearchSubmitClicked(
    SearchSubmitClicked event,
    Emitter<SearchState> emit,
  ) async {
    if ((state.searchQueryController?.text.length ?? 0) < 3) {
      emit(state.copyWith(errorMessage: 'Please enter a bigger search query'));
      return;
    }

    if (state.selectedAutocompleteItem == null) {
      emit(
        state.copyWith(
          errorMessage: 'Please select an item from search dropdown',
        ),
      );
      return;
    }

    if (state.startDate == null || state.endDate == null) {
      emit(state.copyWith(errorMessage: 'Please select date range.'));
      return;
    }

    if (!state.endDate!.isAfter(state.startDate!)) {
      emit(
        state.copyWith(errorMessage: 'Start date should be before end date'),
      );
      return;
    }
    emit(state.copyWith(isLoading: true));
    final results = await _travalyRepo.getSearchResults(
      state.startDate,
      state.endDate,
      state.adultCount,
      state.kidCount,
      state.selectedAutocompleteItem!,
      state.loadedTillPage,
    );
    if (results != null && results.isNotEmpty) {
      emit(
        state.copyWith(
          searchResults: event.loadingMoreData
              ? [...state.searchResults, ...results]
              : results,
          isLoading: false,
          loadedTillPage: state.loadedTillPage + 1,
        ),
      );
    }
  }

  void _onSearchErrorMessageConsumed(
    SearchErrorMessageConsumed event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(errorMessage: ''));
  }
}
