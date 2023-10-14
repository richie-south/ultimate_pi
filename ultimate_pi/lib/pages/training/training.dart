/// This file contains the implementation of the Training widget, which is a StatefulWidget.
/// It displays a training screen for memorizing the digits of pi.
/// The widget imports other widgets such as InputPad, Presenter, and StatusBar.
/// It also imports the Entered class and the piNumbers list.
/// The widget uses SharedPreferences to store and retrieve the top results, top streak, and top points.
/// It contains methods for calculating the correctness of entered values, generating random strings, and calculating streak points.
/// It also has methods for getting the longest streak and the current result, and for saving the top result and top streak.
/// This file contains the implementation of the Training widget, which is a StatefulWidget.
/// It displays a training screen for memorizing the digits of pi.
/// The widget imports other widgets such as InputPad, Presenter, and StatusBar.
/// It also imports the Entered class and the piNumbers list.
/// The widget uses SharedPreferences to store and retrieve the top results, top streak, and top points.
/// It contains methods for calculating the correctness of entered values, generating random strings, and calculating streak points.
/// It also has methods for getting the longest streak and the current result, and for saving the top result and top streak.
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../numbers.dart';
import './input-pad.dart';
import './presenter.dart';
import './status-bar.dart';
import '../../entered.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Training extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Training();
  }
}

class _Training extends State<Training> {
  /* List<Map> values = []; */
  List<Entered> values = [];
  int points = 0;
  DateTime? latestValueTime;
  String streakId = 'id';
  int errors = 0;
  int streak = 0;
  Timer? timer;
  int topResults = 0;
  int topStreak = 0;
  int topPoints = 0;

  @override
  void initState() {
    super.initState();

    getTopResult();
    getTopStreak();
    getTopPoints();
  }

  bool isCorrect(int position, String value) {
    return piNumbers[position] == value;
  }

  String getCorrectPi(int position) {
    return piNumbers[position];
  }

  String _randomString(int length) {
    var rand = Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  void reCalculateValues() {
    int index = 0;
    this.values = this.values.map((Entered value) {
      if (value.isAfter(value.timeNow)) {
        var currentId = value.streakId;
        if (index - 1 != -1) {
          var prev = this.values[index - 1];
          var prevId = prev.streakId;
          var prevCorrect = prev.isCorrect;
          if (prevId == currentId && value.isCorrect && prevCorrect) {
            value.isOnStreak = true;
          }
        }
        if (index + 1 <= this.values.length - 1) {
          var next = this.values[index + 1];
          var nextId = next.streakId;
          var nextCorrect = next.isCorrect;
          if (nextId == currentId && value.isCorrect && nextCorrect) {
            value.isOnStreak = true;
          }
        }
      }
      index += 1;
      return value;
    }).toList();
  }

  int getStreakPoint(int streak) {
    int points = 0;
    for (var i = 1; i <= streak; i++) {
      points += i - 1;
    }
    return points;
  }

  List<int> getLongestStreak(List<Entered> values) {
    int index = 0;

    int longestStreakStartPosition = -1;
    int longestStreakEndPosition = -1;
    int longestStreakLength = 0;

    bool isCurrentrlyOnStreak = false;
    int currentStreakStartPosition = -1;
    int currentStreakEndPosition = -1;
    int currentStreakLength = 0;
    values.forEach((Entered current) {
      // is not first value
      if (index == 0 && values.length > 1) {
        Entered next = values[index + 1];
        if (current.isSameStreakId(next)) {
          // should always be false bu hwo knows..
          if (!isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = true;
            currentStreakStartPosition = index;
            currentStreakLength += 1;
          }
        }
      } else if (index != 0) {
        Entered prevoius = values[index - 1];
        if (current.isSameStreakId(prevoius)) {
          // is first value of streak
          if (!isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = true;
            currentStreakStartPosition = index;
          }

          currentStreakLength += 1;
        } else {
          if (isCurrentrlyOnStreak) {
            isCurrentrlyOnStreak = false;
            currentStreakEndPosition = index;

            if (currentStreakLength > longestStreakLength) {
              longestStreakLength = currentStreakLength;

              longestStreakStartPosition = currentStreakStartPosition;
              longestStreakEndPosition = currentStreakEndPosition;

              currentStreakLength = 0;
              currentStreakStartPosition = -1;
              currentStreakEndPosition = -1;
            }
          }
        }
      }

      // is on streak for last value
      if (index == values.length - 1) {
        if (isCurrentrlyOnStreak) {
          isCurrentrlyOnStreak = false;
          currentStreakEndPosition = index;

          if (currentStreakLength > longestStreakLength) {
            longestStreakLength = currentStreakLength;

            longestStreakStartPosition = currentStreakStartPosition;
            longestStreakEndPosition = currentStreakEndPosition;

            currentStreakLength = 0;
            currentStreakStartPosition = -1;
            currentStreakEndPosition = -1;
          }
        }
      }

      index += 1;
    });

    if (longestStreakStartPosition != 0) {
      longestStreakLength += 1;
      longestStreakStartPosition -= 1;
      longestStreakEndPosition -= 1;
    }

    return [
      longestStreakLength,
      longestStreakStartPosition,
      longestStreakEndPosition
    ];
  }

  int getResult(List<Entered> values) {
    int index = 0;
    for (final value in this.values) {
      if (!value.isCorrect) {
        break;
      }
      index += 1;
    }

    return index;
  }

  void saveRecordLength(int newResult, {bool state = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topResult = (prefs.getInt('topResult') ?? 0);

    if (newResult > topResult) {
      await prefs.setInt('topResult', newResult);
      if (state) {
        setState(() {
          this.topResults = newResult;
        });
      }
    }
  }

  void saveTopStreak(int newStreak, int start, int end,
      {bool state = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topStreak = (prefs.getInt('topStreak') ?? 0);

    if (newStreak > topStreak) {
      await prefs.setInt('topStreak', newStreak);
      await prefs.setInt('streakStart', start);
      await prefs.setInt('streakEnd', end);
      if (state) {
        setState(() {
          this.topStreak = newStreak;
        });
      }
    }
  }

  void saveTopPoints(int points, {bool state = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int topPoints = (prefs.getInt('topPoints') ?? 0);

    if (points > topPoints) {
      await prefs.setInt('topPoints', points);
      if (state) {
        setState(() {
          this.topPoints = points;
        });
      }
    }
  }

  void getTopResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topResult') ?? 0);
    setState(() {
      this.topStreak = value;
    });
  }

  void getTopStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topStreak') ?? 0);
    setState(() {
      this.topStreak = value;
    });
  }

  void getTopPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topPoints') ?? 0);
    setState(() {
      this.topPoints = value;
    });
  }

  @override
  void dispose() {
    super.dispose();

    var streakData = getLongestStreak(this.values);
    int streakLength = streakData[0];
    int streakStartPosition = streakData[1];
    int streakEndPosition = streakData[2];
    int result = getResult(this.values);

    if (streakLength > this.topStreak) {
      saveTopStreak(streakLength, streakStartPosition, streakEndPosition,
          state: false);
    }
    if (result > this.topResults) {
      saveRecordLength(result, state: false);
    }

    if (this.points > this.topPoints) {
      saveTopPoints(this.points, state: false);
    }
  }

  void _checkGuessLessOrMore(int userGuess, int correctAnswer) {
    // close previous snack bar if any
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          userGuess > correctAnswer ? "Too High" : "Too Low",
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void onPress(String value) {
    if (value == 'CLEAR') {
      setState(() {
        if (this.values.length > 1) {
          var streakData = getLongestStreak(this.values);
          int streakLength = streakData[0];
          int streakStartPosition = streakData[1];
          int streakEndPosition = streakData[2];
          int result = getResult(this.values);

          if (streakLength > this.topStreak) {
            saveTopStreak(streakLength, streakStartPosition, streakEndPosition);
          }
          if (result > this.topResults) {
            saveRecordLength(result);
          }

          if (this.points > this.topPoints) {
            saveTopPoints(this.points);
          }
        }

        this.points = 0;
        this.errors = 0;
        this.values.clear();
        this.streak = 0;
        this.streakId = this._randomString(10);
        this.latestValueTime = null;
        if (this.timer != null) {
          this.timer!.cancel();
        }
      });
    } else {
      setState(() {
        var isCorrect = this.isCorrect(this.values.length, value);
        if (!isCorrect) {
          _checkGuessLessOrMore(
              int.parse(value), int.parse(getCorrectPi(this.values.length)));
          this.errors = this.errors + 1;
          this.streakId = this._randomString(10);
          this.latestValueTime = null;
          this.reCalculateValues();
          if (this.timer != null) {
            if (this.streak > 1) {
              this.points += getStreakPoint(this.streak);
            }
            this.timer!.cancel();
          }
          this.streak = 0;
        } else {
          this.points += 1;
        }

        var timeNow = DateTime.now();
        var time = latestValueTime == null ? DateTime.now() : latestValueTime;
        var plusFive = time!.add(Duration(milliseconds: 400));
        if (isCorrect) {
          if (plusFive.isBefore(timeNow)) {
            if (this.timer != null) {
              this.timer!.cancel();
            }
            this.latestValueTime = DateTime.now();
            plusFive = DateTime.now();
            this.streakId = this._randomString(10);
            if (this.streak > 1) {
              this.points += getStreakPoint(this.streak);
            }
            this.streak = 1;
            this.reCalculateValues();
          } else {
            this.streak = this.streak + 1;

            if (this.timer != null) {
              this.timer!.cancel();
            }
            this.timer = Timer(new Duration(seconds: 1), () {
              setState(() {
                if (this.streak > 1) {
                  this.points += getStreakPoint(this.streak);
                }
                this.streak = 0;
                this.streakId = this._randomString(10);
                this.reCalculateValues();
                this.latestValueTime = null;
              });
            });
          }
        }

        Entered entered = Entered(
          value: value,
          inputTime: plusFive,
          timeNow: timeNow,
          isCorrect: isCorrect,
          streakId: this.streakId,
          position: this.values.length,
          correctValue: getCorrectPi(this.values.length),
        );

        this.values.add(entered);
        this.latestValueTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: Presenter(
            streak: this.streak,
            values: this.values,
            errors: this.errors,
          ),
        ),
        StatusBar(
          errors: this.errors,
          points: this.points,
          digits: this.values.length,
          streak: this.streak,
        ),
        Expanded(
          flex: 0,
          child: Pad(
            onPress: this.onPress,
            disableClear: this.streak > 2,
          ),
        ),
      ],
    ));
  }
}
