import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/search/bloc/search_bloc.dart';

class PersonPicker extends StatelessWidget {
  const PersonPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(
      context,
    ).bodyLarge?.copyWith(color: ColorScheme.of(context).onTertiaryContainer);
    final bloc = context.read<SearchBloc>();
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Adults', style: style),
                    Adder(
                      value: state.adultCount.toString(),
                      onIncremented: () {
                        bloc.add(SearchAdultIncremented());
                      },
                      onDecremented: () {
                        bloc.add(SearchAdultDecremented());
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Kids', style: style),
                    Adder(
                      value: state.kidCount.toString(),
                      onIncremented: () {
                        bloc.add(SearchKidIncremented());
                      },
                      onDecremented: () {
                        bloc.add(SearchKidDecremented());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Adder extends StatelessWidget {
  const Adder({
    super.key,
    required this.value,
    required this.onIncremented,
    required this.onDecremented,
  });

  final String value;
  final VoidCallback onIncremented;
  final VoidCallback onDecremented;

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(
      context,
    ).bodyLarge?.copyWith(color: ColorScheme.of(context).onTertiaryContainer);
    return Row(
      children: [
        IconButton(onPressed: onIncremented, icon: Icon(Icons.add)),
        Text(value, style: style),
        IconButton(onPressed: onDecremented, icon: Icon(Icons.remove)),
      ],
    );
  }
}
