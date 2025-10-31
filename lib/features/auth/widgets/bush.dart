import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math; // Required for random number generation and pi

class DenserBushWidget extends StatelessWidget {
  // Use a final Random instance to generate pseudo-random numbers
  final math.Random _random = math.Random();
  final int _numberOfLeaves = 10;

  // A list of green shades to pick from, for color variation
  final List<Color> _greenShades = [
    Colors.green.shade900,
    Colors.green.shade700,
    Colors.green.shade600,
    Colors.lightGreen.shade300,
  ];

  Widget _buildLeaf(int index) {
    final double angle = (_random.nextDouble() - 0.5) * math.pi;
    final double scale = 0.8 + _random.nextDouble() * 0.7;
    final Color color = _greenShades[_random.nextInt(_greenShades.length)];
    final double offsetY = ((_random.nextDouble() - 0.5) * 50) + 30;

    return Positioned(
      left: index * 30,
      bottom: offsetY,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: Icon(
            Icons.energy_savings_leaf,
            color: color,
            size: 50.0, // Base size
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        // Use List.generate to create the specified number of leaves
        children: List.generate(_numberOfLeaves, (index) => _buildLeaf(index)),
      ),
    );
  }
}

class LeafBackground extends StatelessWidget {
  const LeafBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.topLeft, child: DenserBushWidget()),
        Align(alignment: Alignment.bottomRight, child: DenserBushWidget()),
        child,
      ],
    );
  }
}
