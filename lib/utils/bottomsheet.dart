import 'package:flutter/material.dart';

class BottomSheetLayoutHelper {
  static double calculateSearchPadding({
    required BuildContext context,
    required bool isArrowVisible,    // widgets enabled/disabled
    required bool isFavoritesVisible, // favorites enabled/disabled
    required bool hasApps,           // apps are pinned
  }) {
    // Base calculation without system padding
    double baseHeight;

    if (isArrowVisible && isFavoritesVisible) {
      // When widgets AND favorites are enabled AND apps are pinned
      baseHeight = 85.0;
    } else if (!isArrowVisible && isFavoritesVisible) {
      // When widgets are disabled BUT favorites are enabled AND apps are pinned
      baseHeight = 55.0;
    } else if (isArrowVisible) {
      // When only widgets are enabled (no favorites or apps)
      baseHeight = 40.0;
    } else {
      // Default case - everything disabled
      baseHeight = 20.0;
    }

    // Add system padding
    return baseHeight + MediaQuery.of(context).padding.bottom;
  }
}