import 'package:flutter/material.dart';
import 'responsive_constants.dart';
import 'screen_type.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType, Size size) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final Size size = Size(width, height);
        
        ScreenType screenType = ScreenType.desktop;

        if (width <= ResponsiveConstants.mobileMax) {
          screenType = ScreenType.mobile;
        } else if (width <= ResponsiveConstants.tabletMax) {
          screenType = ScreenType.tablet;
        }

        return builder(context, screenType, size);
      },
    );
  }
}
