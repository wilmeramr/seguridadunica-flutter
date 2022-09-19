import 'package:flutter/material.dart';

class AnimatedExpandingContainer extends StatelessWidget {
  final Widget unexpandedWidget;
  final Widget expandedWidget;
  final bool isExpanded;

  const AnimatedExpandingContainer(
      {required this.unexpandedWidget,
      required this.expandedWidget,
      required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: Curves.bounceInOut,
      secondCurve: Curves.easeInOutExpo,
      firstChild: unexpandedWidget,
      secondChild: expandedWidget,
      crossFadeState:
          !isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(microseconds: 800000),
    );
  }
}
