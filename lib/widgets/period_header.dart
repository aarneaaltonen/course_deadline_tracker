import 'package:flutter/material.dart';

import '../constants.dart';

class PeriodHeader extends StatelessWidget {
  final String periodText;
  final DateTime startDate;
  final DateTime endDate;

  PeriodHeader(
      {required this.periodText,
      required this.startDate,
      required this.endDate});

  @override
  Widget build(BuildContext context) {
    final int daysBetween = endDate.difference(startDate).inDays + 1;
    final double width = daysBetween * 4.0 * AppConstants.scalingFactor;
    return SizedBox(
      width: width,
      height: 40,
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
