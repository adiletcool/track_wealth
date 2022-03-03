import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedSwitcherWithTransition extends StatefulWidget {
  final bool showFirst;
  final Widget firstChild;
  final Widget secondChild;

  final Duration? duration;
  final Tween<Offset>? firstTween;
  final Animation<double>? firstAnimation;
  final Tween<Offset>? secondTween;
  final Animation<double>? secondAnimation;
  final String firstChildKey;

  const AnimatedSwitcherWithTransition({
    Key? key,
    required this.showFirst,
    required this.firstChild,
    required this.secondChild,
    required this.firstChildKey,
    this.firstTween,
    this.firstAnimation,
    this.secondTween,
    this.secondAnimation,
    this.duration,
  }) : super(key: key);

  @override
  State<AnimatedSwitcherWithTransition> createState() => _AnimatedSwitcherWithTransitionState();
}

class _AnimatedSwitcherWithTransitionState extends State<AnimatedSwitcherWithTransition> {
  late final Tween<Offset> firstTween;
  late final Tween<Offset> secondTween;

  @override
  void initState() {
    super.initState();
    firstTween = widget.firstTween ?? Tween<Offset>(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0));
    secondTween = widget.secondTween ?? Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration ?? 200.milliseconds,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final inAnimation = firstTween.animate(widget.firstAnimation ?? CurvedAnimation(parent: animation, curve: Curves.easeInOutSine));

        final outAnimation = secondTween.animate(widget.secondAnimation ?? CurvedAnimation(parent: animation, curve: Curves.easeInOutSine));

        return SlideTransition(
          position: child.key == ValueKey(widget.firstChildKey) ? inAnimation : outAnimation,
          child: child,
        );
      },
      child: widget.showFirst ? widget.firstChild : widget.secondChild,
    );
  }
}
