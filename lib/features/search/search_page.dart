import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/search/bloc/search_bloc.dart';
import 'package:travaly/features/search/widgets/date_range_picker.dart';
import 'package:travaly/features/search/widgets/person_picker.dart';
import 'package:travaly/features/search/widgets/search_result_list.dart';
import 'package:travaly/features/search/widgets/suggestions_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage._({super.key});

  static create() {
    return BlocProvider(
      create: (context) => SearchBloc(travalyRepo: context.read()),
      child: SearchPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          context.read<SearchBloc>().add(SearchErrorMessageConsumed());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: context
                      .read<SearchBloc>()
                      .state
                      .searchQueryController,
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).onSecondaryContainer,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    context.read<SearchBloc>().add(
                      SearchQueryChanged(query: query),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SuggestionsCard(),
                DateRangePicker(),
                PersonPicker(),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: FilledButton(
                    onPressed: () {
                      context.read<SearchBloc>().add(SearchSubmitClicked());
                    },
                    child: Text('Search'),
                  ),
                ),
                SearchResultList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
