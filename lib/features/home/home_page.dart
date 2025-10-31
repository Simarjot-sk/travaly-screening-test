import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/home/bloc/home_bloc.dart';
import 'package:travaly/features/home/widgets/hotel_list.dart';

class HomePage extends StatelessWidget {
  const HomePage._({super.key});

  static create() {
    return BlocProvider(
      create: (context) =>
          HomeBloc(travalyRepo: context.read())
            ..add(HomeInitialDataRequested()),
      child: HomePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Recommended Hotels',
                style: TextTheme.of(context).displayMedium?.copyWith(
                  color: ColorScheme.of(context).onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: HotelList()),
            ],
          ),
        ),
      ),
    );
  }
}
