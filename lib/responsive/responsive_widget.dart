import 'package:flutter/material.dart';
import 'responsive_builder.dart';
import 'screen_type.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context)? mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType, size) {
        switch (screenType) {
          case ScreenType.mobile:
            if (mobile != null) return mobile!(context);
            break;
          case ScreenType.tablet:
            if (tablet != null) return tablet!(context);
            if (mobile != null) return mobile!(context);
            break;
          case ScreenType.desktop:
            if (desktop != null) return desktop!(context);
            break;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
