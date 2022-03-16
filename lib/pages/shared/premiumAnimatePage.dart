import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class AnimatePage extends StatefulWidget {
  final Animation<double> transitionAnimation;
  const AnimatePage({Key? key, 
    required this.transitionAnimation
  }) : super(key: key);
  
  @override
  _AnimatePageState createState() => _AnimatePageState();
}

class _AnimatePageState extends State<AnimatePage> {
  @override
  void initState() {
    widget.transitionAnimation.addStatusListener((status) async{
      if(status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: widget.transitionAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: widget.transitionAnimation,
                curve: const  MyBounceOutCurve._(),
                reverseCurve: Curves.linear
              )
            ),
            child: Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, -0.15),
                  colors: [Colors.white, Color(0xff1d9fb8)]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    premiumIconPng,
                    width: 37,
                    height: 37,
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    premiumTextPng,
                    width: 108,
                    height: 32,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyBounceOutCurve extends Curve {
  const MyBounceOutCurve._();

  @override
  double transformInternal(double t) {
    return _bounce(t);
  }
}

double _bounce(double t) {
  if (t < 0.7) {
    return 100/49 * t * t;
  } 

  t = t - 0.85;
  return 40/9 * t * t + 0.9 ;
}