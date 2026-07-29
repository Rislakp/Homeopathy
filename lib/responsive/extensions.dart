import 'package:flutter/material.dart';
import 'responsive_constants.dart';
import 'screen_type.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  ScreenType get screenType {
    final double width = screenWidth;
    if (width <= ResponsiveConstants.mobileMax) {
      return ScreenType.mobile;
    } else if (width <= ResponsiveConstants.tabletMax) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop;
    }
  }
}
