import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/search/bloc/search_bloc.dart';

class SuggestionsCard extends StatelessWidget {
  const SuggestionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.autoCompleteItems.isEmpty) {
          return SizedBox();
        }
        return SizedBox(
          height: 300,
          child: Card(
            color: ColorScheme.of(context).primaryContainer,
            child: ListView.builder(
              itemCount: state.autoCompleteItems.length,
              itemBuilder: (context, index) {
                var item = state.autoCompleteItems[index];
                return ListTile(
                  onTap: () {
                    context.read<SearchBloc>().add(
                      SearchSuggestionClicked(suggestion: item),
                    );
                  },
                  leading: Icon(
                    item.itemType == 'place' ? Icons.place : Icons.home_filled,
                  ),
                  title: Text(
                    item.itemName,
                    style: TextTheme.of(context).bodyLarge?.copyWith(
                      color: ColorScheme.of(context).onPrimaryContainer,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
