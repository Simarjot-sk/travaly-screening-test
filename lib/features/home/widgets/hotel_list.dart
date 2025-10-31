import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/features/home/bloc/home_bloc.dart';
import 'package:travaly/features/home/widgets/hotel_list_item.dart';

class HotelList extends StatelessWidget {
  const HotelList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if(state.isLoading){
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => HotelListItemShimmer(),
          );
        }
        if (state.hotels.isNotEmpty) {
          return ListView.builder(
            itemCount: state.hotels.length,
            itemBuilder: (context, index) {
              return HotelListItem(propertyDto: state.hotels[index]);
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
