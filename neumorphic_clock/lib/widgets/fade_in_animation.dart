import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation(
      {Key key,
      this.child,
      this.duration = const Duration(seconds: 1),
      this.delay = const Duration(seconds: 6)})
      : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  _FadeInAnimationState createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));

    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {});
      }
    });

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
    return Opacity(
      opacity: _animation.value,
      child: widget.child,
    );
  }
}
