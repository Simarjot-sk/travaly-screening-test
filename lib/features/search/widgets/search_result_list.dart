import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/home/widgets/hotel_list_item.dart';
import 'package:travaly/features/search/bloc/search_bloc.dart';

class SearchResultList extends StatefulWidget {
  const SearchResultList({super.key});

  @override
  State<SearchResultList> createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User reached the bottom, trigger data fetch
        context.read<SearchBloc>().add(SearchSubmitClicked(loadingMoreData: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.isLoading && state.loadedTillPage == 0/*initial load*/) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => HotelListItemShimmer(),
            );
          }
          return Stack(
            children: [
              ListView.builder(
                itemCount: state.searchResults.length,
                itemBuilder: (context, index) {
                  return HotelListItem(propertyDto: state.searchResults[index]);
                },
                controller: _scrollController,
              ),
              if(state.isLoading) Center(child: CircularProgressIndicator())
            ],
          );
        },
      ),
    );
  }
}
