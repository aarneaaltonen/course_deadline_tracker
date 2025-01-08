import 'package:flutter/material.dart';

import '../constants.dart';

class PeriodHeader extends StatelessWidget {
  final String periodText;

  PeriodHeader({required this.periodText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants().periodHeaderWidth,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 189, 216, 236),
            border: Border.all(color: const Color.fromARGB(255, 74, 74, 74)),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            periodText,
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
    );
  }
}
