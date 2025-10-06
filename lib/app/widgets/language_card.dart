// FILE: lib/app/widgets/language_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';


class LanguageCard extends StatelessWidget {
  final String name;
  final String iconPath;

  const LanguageCard({
    super.key,
    required this.name,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // *** THIS IS THE FIX ***
        onTap: () {
          // Instead of showing a snackbar, navigate to the problems screen
          Get.toNamed(Routes.PRACTICE_PROBLEMS, arguments: name);
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(iconPath, style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}