import 'package:cowlar_entry_test_app/constants.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgGrey,
      child: const Center(
        child: Text(
          'Not implemented yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: navBarColor,
          ),
        ),
      ),
    );
  }
}
