import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Duration? duration;
  final Curve curve;
  final double axisAlignment;

  const ExpandedSection({
    Key? key,
    required this.child,
    this.expand = true,
    this.duration,
    this.curve = Curves.easeInOutQuad,
    this.axisAlignment = 1.0,
  }) : super(key: key);

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  late final AnimationController expandController;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration ?? 300.milliseconds,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.curve,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
