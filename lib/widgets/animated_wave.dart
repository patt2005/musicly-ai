import 'package:flutter/material.dart';

class AnimatedWave extends StatefulWidget {
  final int duration;
  final Color color;
  final bool isPaused;

  const AnimatedWave({
    super.key,
    required this.duration,
    required this.color,
    required this.isPaused,
  });

  @override
  State<AnimatedWave> createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInCirc,
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        if (!widget.isPaused) {
          setState(() {});
        }
      });
    _animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animation != null
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 10,
            height: _animation!.value,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }
}
