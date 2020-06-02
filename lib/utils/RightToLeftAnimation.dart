import 'package:flutter/material.dart';

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation2, child) {
      return  SlideTransition(
        transformHitTests: false,
        position: new Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation1),
        child: new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(animation2),
          child: child,
        ),
      );
    },
  );
}