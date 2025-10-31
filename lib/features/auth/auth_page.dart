import 'package:flutter/material.dart';
import 'package:travaly/features/auth/widgets/bush.dart';
import 'package:travaly/features/auth/widgets/logo.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeafBackground(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(flex: 5),
                Logo(),
                Spacer(flex: 3),
                Card(
                  color: ColorScheme.of(context).secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Find an epic stay with us!',
                      style: TextTheme.of(context).headlineLarge?.copyWith(
                        color: ColorScheme.of(context).onSecondaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Text(
                  'Hotels, Resorts, Holiday Homes, Villas, Co-living And More At Best Price',
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).onSecondaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 6),
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text('Login with Google', style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).onPrimaryContainer
                  ),),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
