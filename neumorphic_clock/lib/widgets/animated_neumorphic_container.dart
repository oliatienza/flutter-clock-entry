import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

enum NeumorphicContainerShape { RoundedRectangle, Circle }

class AnimatedNeumorphicContainer extends StatefulWidget {
  const AnimatedNeumorphicContainer(
      {Key key,
      this.child,
      this.shadowOffset = SHADOW_OFFSET,
      this.blurAmount = SHADOW_BLUR,
      this.delay,
      this.shape = NeumorphicContainerShape.RoundedRectangle})
      : super(key: key);

  final Widget child;
  final double shadowOffset;
  final double blurAmount;
  final Duration delay;
  final NeumorphicContainerShape shape;

  @override
  _AnimatedNeumorphicContainerState createState() =>
      _AnimatedNeumorphicContainerState();
}

class _AnimatedNeumorphicContainerState
    extends State<AnimatedNeumorphicContainer> with TickerProviderStateMixin {
  AnimationController _controller, _fadeController;
  Animation<Color> _lightShadowColorAnimation, _darkShadowColorAnimation;
  Animation<Offset> _lightShadowOffsetAnimation, _darkShadowOffsetAnimation;
  Animation<double> _opacityAnimation;
  bool _isLightMode = true;
  bool _isDoneAnimatingContainer = false;
  Color _lightShadowColorEndValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isLightMode = Theme.of(context).brightness == Brightness.light;
    _lightShadowColorEndValue =
        _isLightMode ? Colors.white54 : DARK_DARK_SHADOW_COLOR;
  }

  @override
  void initState() {
    super.initState();

    _lightShadowColorEndValue =
        _isLightMode ? Colors.white54 : DARK_DARK_SHADOW_COLOR;

    // Setup animation controllers
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _fadeController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Setup animations
    _lightShadowColorAnimation = ColorTween(
            begin:
                _isLightMode ? LIGHT_BACKGROUND_COLOR : DARK_BACKGROUND_COLOR,
            end: _lightShadowColorEndValue)
        .animate(
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
    _darkShadowColorAnimation = ColorTween(
            begin:
                _isLightMode ? LIGHT_BACKGROUND_COLOR : DARK_BACKGROUND_COLOR,
            end: Colors.black26)
        .animate(
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
    _lightShadowOffsetAnimation = Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset(-widget.shadowOffset, -widget.shadowOffset))
        .animate(
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
    _darkShadowOffsetAnimation = Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset(widget.shadowOffset, widget.shadowOffset))
        .animate(
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _fadeController));

    // Add listener for updating the UI
    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {});
      }

      if (_controller.isCompleted) {
        setState(() {
          _isDoneAnimatingContainer = true;
        });

        _fadeController.addListener(() {
          if (_fadeController.isAnimating) {
            setState(() {});
          }
        });

        _fadeController.forward();
      }
    });

    // Start the animation
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: widget.shape == NeumorphicContainerShape.RoundedRectangle
            ? BoxShape.rectangle
            : BoxShape.circle,
        borderRadius: BorderRadius.circular(16),
        color: _isLightMode ? LIGHT_BACKGROUND_COLOR : DARK_BACKGROUND_COLOR,
        boxShadow: <BoxShadow>[
          // Dark
          BoxShadow(
            color: _darkShadowColorAnimation.value,
            blurRadius: widget.blurAmount,
            offset: _darkShadowOffsetAnimation.value,
          ),
          // Light
          BoxShadow(
            color: _isDoneAnimatingContainer
                ? _lightShadowColorEndValue
                : _lightShadowColorAnimation.value,
            blurRadius: widget.blurAmount,
            offset: _lightShadowOffsetAnimation.value,
          ),
        ],
      ),
      child: Opacity(
        child: widget.child,
        opacity: _opacityAnimation.value,
      ),
    );
  }
}
