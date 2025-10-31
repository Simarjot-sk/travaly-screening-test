class SearchAutocompleteItemDto {
  final String itemName;
  final String itemType;
  final List<String>? queries;
  final String searchType;

  const SearchAutocompleteItemDto({
    this.itemName = '',
    this.itemType = '',
    this.queries = const [],
    this.searchType = ''
  });
}
