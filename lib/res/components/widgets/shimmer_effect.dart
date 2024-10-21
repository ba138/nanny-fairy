import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerUi extends StatelessWidget {
  const ShimmerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 5, // Number of shimmer placeholders
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 100.0,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
