import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/search/bloc/search_bloc.dart';

class DateRangePicker extends StatelessWidget {
  const DateRangePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(
      context,
    ).bodyLarge?.copyWith(color: ColorScheme.of(context).onTertiaryContainer);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 100)),
                    );
                    if (date != null) {
                      context.read<SearchBloc>().add(
                        SearchStartDateSelected(startDate: date),
                      );
                    }
                  },
                  child: Text(state.startDateFormatted, style: textTheme),
                ),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 100)),
                    );
                    if (date != null) {
                      context.read<SearchBloc>().add(
                        SearchEndDateSelected(endDate: date),
                      );
                    }
                  },
                  child: Text(state.endDateFormatted, style: textTheme),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
