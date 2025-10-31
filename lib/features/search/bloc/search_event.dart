part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});
}

class SearchSuggestionClicked extends SearchEvent {
  final SearchAutocompleteItemDto suggestion;

  const SearchSuggestionClicked({required this.suggestion});
}

class SearchStartDateSelected extends SearchEvent {
  final DateTime startDate;

  const SearchStartDateSelected({required this.startDate});
}

class SearchEndDateSelected extends SearchEvent {
  final DateTime endDate;

  const SearchEndDateSelected({required this.endDate});
}

class SearchAdultIncremented extends SearchEvent {}

class SearchAdultDecremented extends SearchEvent {}

class SearchKidIncremented extends SearchEvent {}

class SearchKidDecremented extends SearchEvent {}

class SearchSubmitClicked extends SearchEvent {
  final bool loadingMoreData;

  const SearchSubmitClicked({
    this.loadingMoreData = false,
  });
}

class SearchErrorMessageConsumed extends SearchEvent {}
