import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:travaly/data/model/property_dto.dart';

class HotelListItem extends StatelessWidget {
  const HotelListItem({super.key, required this.propertyDto});

  final PropertyDto propertyDto;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: ColorScheme.of(context).primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  propertyDto.propertyImage ?? '',
                  errorBuilder: (context, err, stack) => Icon(Icons.image),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                propertyDto.propertyName,
                style: TextTheme.of(context).bodyLarge?.copyWith(
                  color: ColorScheme.of(context).onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (propertyDto.address?.city != null)
                Row(
                  children: [
                    Icon(Icons.location_on, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      propertyDto.address!.city!,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: ColorScheme.of(context).onPrimaryContainer,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${propertyDto.rate}/night',
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: ColorScheme.of(context).onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HotelListItemShimmer extends StatelessWidget {
  const HotelListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: ColorScheme.of(context).primaryContainer,
      child: Container(
        width: double.infinity,
        height: 150,
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
