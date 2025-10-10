// lib/widgets/language_card.dart

import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String name;
  final String? iconPath;
  final VoidCallback? onTap; // <-- 1. ADDED THIS

  const LanguageCard({
    super.key,
    required this.name,
    required this.iconPath,
    this.onTap, // <-- 2. ADDED TO CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap, // <-- 3. USE THE PASSED-IN ONTAP
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Assuming iconPath is an emoji or placeholder for now
            Text(iconPath!, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}