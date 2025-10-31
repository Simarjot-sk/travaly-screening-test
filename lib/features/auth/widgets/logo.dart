import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: ColorScheme.of(context).tertiary,
          ),
          child: Text(
            'MT',
            style: TextTheme.of(context).displayLarge?.copyWith(
              color: ColorScheme.of(context).onTertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'MyTravaly',
          style: TextTheme.of(
            context,
          ).bodyLarge?.copyWith(color: ColorScheme.of(context).onSurface),
        ),
      ],
    );
  }
}
