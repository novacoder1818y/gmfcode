import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../theme/app_theme.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String category;
  final double progress;
  final List<String> tags;
  final VoidCallback onTap; // <-- THIS IS THE FIX (Part 1)

  const ChallengeCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.tags,
    required this.onTap, // <-- THIS IS THE FIX (Part 1)
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap, // <-- THIS IS THE FIX (Part 1)
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(title,
                          style: Theme.of(context).textTheme.titleLarge)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(category,
                        style: const TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: tags
                    .map((tag) => Chip(label: Text(tag), padding: EdgeInsets.zero))
                    .toList(),
              ),
              const SizedBox(height: 15),
              LinearPercentIndicator(
                percent: progress,
                lineHeight: 8.0,
                barRadius: const Radius.circular(5),
                progressColor: AppTheme.accentColor,
                backgroundColor: Colors.grey[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}