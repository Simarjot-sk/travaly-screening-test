import 'package:flutter/material.dart';
import 'package:travaly/features/search/search_page.dart';

class HotelSearchBar extends StatelessWidget {
  const HotelSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage.create()),
        );
      },
      decoration: InputDecoration(
        filled: true,
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
