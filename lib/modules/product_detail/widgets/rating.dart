import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  final double ratingsAvg;
  final int ratingsCount;
  final Map<String, dynamic> Function(String starKey) getStarDistribution;

  const Review({
    super.key,
    required this.ratingsAvg,
    required this.ratingsCount,
    required this.getStarDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ratings & Reviews",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Rating Summary
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    ratingsAvg.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < ratingsAvg.round() ? Colors.orange : Colors.grey[300],
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$ratingsCount ratings",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right Side: Progress Bars
            Expanded(
              flex: 7,
              child: Column(
                children: ['5', '4', '3', '2', '1'].map((starKey) {
                  final data = getStarDistribution(starKey);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                          child: Text(
                            starKey,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: data['ratio'] ?? 0.0,
                              backgroundColor: const Color(0xFFF5F5F5),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 35,
                          child: Text(
                            data['percentText'] ?? '0%',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}