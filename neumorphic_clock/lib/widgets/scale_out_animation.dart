import 'package:flutter/material.dart';

class ScaleOutAnimation extends StatefulWidget {
  const ScaleOutAnimation(
      {Key key,
      this.child,
      this.duration = const Duration(milliseconds: 500),
      this.delay})
      : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  _ScaleOutAnimationState createState() => _ScaleOutAnimationState();
}

class _ScaleOutAnimationState extends State<ScaleOutAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));

    if (widget.delay != null) {
      Future<void>.delayed(widget.delay, () {
        _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      child: widget.child,
      scale: _animation,
    );
  }
}
