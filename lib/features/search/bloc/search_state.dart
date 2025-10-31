part of 'search_bloc.dart';

@immutable
class SearchState extends Equatable {
  final bool isLoading;
  final List<SearchAutocompleteItemDto> autoCompleteItems;
  final TextEditingController? searchQueryController;
  final DateTime? startDate;
  final String startDateFormatted;
  final DateTime? endDate;
  final String endDateFormatted;
  final int adultCount;
  final int kidCount;
  final String errorMessage;
  final List<PropertyDto> searchResults;
  final SearchAutocompleteItemDto? selectedAutocompleteItem;
  final int loadedTillPage;

  const SearchState({
    this.isLoading = false,
    this.autoCompleteItems = const [],
    this.searchQueryController,
    this.startDate,
    this.endDate,
    this.startDateFormatted = 'Start Date',
    this.endDateFormatted = 'End Date',
    this.adultCount = 1,
    this.kidCount = 0,
    this.errorMessage = '',
    this.searchResults = const [],
    this.selectedAutocompleteItem,
    this.loadedTillPage = 0,
  });

  @override
  List<Object?> get props => [
    isLoading,
    autoCompleteItems,
    startDate,
    endDate,
    adultCount,
    kidCount,
    errorMessage,
    searchResults,
    selectedAutocompleteItem,
    loadedTillPage,
  ];

  SearchState copyWith({
    bool? isLoading,
    List<SearchAutocompleteItemDto> Function()? autoCompleteItems,
    DateTime? startDate,
    DateTime? endDate,
    String? startDateFormatted,
    String? endDateFormatted,
    int? adultCount,
    int? kidCount,
    String? errorMessage,
    List<PropertyDto>? searchResults,
    SearchAutocompleteItemDto? selectedAutocompleteItem,
    int? loadedTillPage,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      autoCompleteItems: autoCompleteItems != null
          ? autoCompleteItems()
          : this.autoCompleteItems,
      searchQueryController: searchQueryController,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateFormatted: startDateFormatted ?? this.startDateFormatted,
      endDateFormatted: endDateFormatted ?? this.endDateFormatted,
      adultCount: adultCount ?? this.adultCount,
      kidCount: kidCount ?? this.kidCount,
      errorMessage: errorMessage ?? this.errorMessage,
      searchResults: searchResults ?? this.searchResults,
      selectedAutocompleteItem:
          selectedAutocompleteItem ?? this.selectedAutocompleteItem,
      loadedTillPage: loadedTillPage ?? this.loadedTillPage,
    );
  }
}
