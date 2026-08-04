import 'package:flutter/material.dart';

final class AppContent extends StatelessWidget {
  const AppContent({
    required this.child,
    this.maxContentWidth = 720,
    this.padding = const EdgeInsets.all(24),
    super.key,
  });

  final Widget child;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth < maxContentWidth
              ? constraints.maxWidth
              : maxContentWidth,
        ),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}
