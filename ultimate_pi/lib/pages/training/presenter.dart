import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import '../../entered.dart';

class Presenter extends StatefulWidget {
  final List<Entered> values;
  final int streak;
  final int errors;

  Presenter({
    @required this.values,
    @required this.streak,
    @required this.errors,
  });

  @override
  State<StatefulWidget> createState() {
    return _Presenter();
  }
}

class _Presenter extends State<Presenter> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<int> reveals = [];
  Timer timer;

  @override
  initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      });
  }

  @override
  void didUpdateWidget(Presenter oldWidget) {
    if (widget.errors > oldWidget.errors) {
      animationController.reset();
      animationController.forward();
    }
    reveals.clear();
  }

  Widget buildPiSequence(BuildContext context) {
    int index = 0;
    bool useAlternateColor = false;
    String alternateStreakId = '';
    return RichText(
      text: TextSpan(
          text: '3.',
          style: TextStyle(
              fontSize: 70.0, fontWeight: FontWeight.w600, color: Colors.white),
          children: this.widget.values.map((Entered value) {
            if (index - 1 != -1) {
              var prev = widget.values[index - 1];
              if (prev.isCorrect &&
                  prev.isOnStreak &&
                  prev.streakId != value.streakId &&
                  !useAlternateColor) {
                alternateStreakId = value.streakId;
                useAlternateColor = true;
              } else {
                if (value.streakId == alternateStreakId) {
                  useAlternateColor = true;
                } else {
                  alternateStreakId = '';
                  useAlternateColor = false;
                }

                if (!prev.isCorrect) {
                  alternateStreakId = '';
                  useAlternateColor = false;
                }
              }
            }

            bool shouldReveal = reveals.contains(index);
            TextSpan textSpan = TextSpan(
              text: shouldReveal ? value.correctValue : value.value,
              style: TextStyle(
                  fontWeight:
                      value.isCorrect ? FontWeight.normal : FontWeight.w600,
                  fontSize: 60.0,
                  letterSpacing: 8.0,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationColor:
                      useAlternateColor ? Colors.blue[100] : Colors.blue,
                  decoration: value.isOnStreak
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: value.isCorrect
                      ? Colors.white
                      : shouldReveal ? Colors.lightGreen[400] : Colors.red),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (!value.isCorrect) {
                    setState(() {
                      if (reveals.contains(value.position)) {
                        reveals.remove(value.position);
                      } else {
                        reveals.add(value.position);
                      }
                    });
                  }
                },
            );
            index += 1;
            return textSpan;
          }).toList()),
    );
  }

  v.Vector3 getTranslation() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 20) * 10;
    return v.Vector3(offset, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
      child: Transform(
        transform: Matrix4.translation(getTranslation()),
        child: SingleChildScrollView(
          reverse: true,
          child: buildPiSequence(context),
        ),
      ),
    );
  }
}
