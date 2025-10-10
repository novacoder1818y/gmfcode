// lib/services/level_service.dart

import 'dart:math';

class LevelService {
  // Calculates the XP required for a specific level.
  // Using a simple formula for this example: 1000 XP per level.
  int xpForLevel(int level) {
    return level * 1000;
  }

  // Calculates the user's current level based on their total XP.
  int calculateLevel(int totalXp) {
    if (totalXp < 0) return 1;
    // Every 1000 XP points equals one level. Level 1 is the base.
    return (totalXp / 1000).floor() + 1;
  }

  // Calculates the user's progress towards the next level as a percentage (0.0 to 1.0).
  double calculateLevelProgress(int totalXp) {
    final int currentLevel = calculateLevel(totalXp);
    final int xpForCurrentLevel = xpForLevel(currentLevel - 1);
    final int xpForNextLevel = xpForLevel(currentLevel);

    final int xpInCurrentLevel = totalXp - xpForCurrentLevel;
    final int xpNeededForNextLevel = xpForNextLevel - xpForCurrentLevel;

    if (xpNeededForNextLevel == 0) return 0; // Avoid division by zero

    return max(0, min(1, xpInCurrentLevel / xpNeededForNextLevel));
  }

  // Gets the XP required for the next level from the current total XP.
  int getNextLevelXp(int totalXp) {
    final int currentLevel = calculateLevel(totalXp);
    return xpForLevel(currentLevel);
  }
}