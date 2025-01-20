import 'package:flutter/material.dart';

class FoodLoader extends StatefulWidget {
  const FoodLoader({super.key});

  @override
  State<FoodLoader> createState() => _FoodLoaderState();
}

class _FoodLoaderState extends State<FoodLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(period: const Duration(seconds: 1));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reset();
        _controller.repeat(period: const Duration(seconds: 1)); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller.drive(Tween(begin: 0.0, end: 3.0)), 
        child: ClipOval(child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Image.asset('assets/images/onebanc_logo.jpeg', width: 70, height: 70,fit: BoxFit.cover,),
        )),
      ),
    );
  }
}