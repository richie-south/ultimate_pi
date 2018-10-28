import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../numbers.dart';

class References extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _References();
  }
}

class _References extends State<References> {
  int maxNumbersToRender = 100;

  int topResults = 0;
  int streakStart = 0;
  int streakEnd = 0;

  @override
  void initState() {
    super.initState();
    getTopResult();
    getTopStreak();
  }

  void getTopResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topResult') ?? 0);
    setState(() {
      this.topResults = value;
    });
  }

  void getTopStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int start = (prefs.getInt('streakStart') ?? 0);
    int end = (prefs.getInt('streakEnd') ?? 0);
    setState(() {
      this.streakStart = start;
      this.streakEnd = end;
    });
  }

  List<TextSpan> getNumbersToRender() {
    if (maxNumbersToRender > piNumbers.length) {
      maxNumbersToRender = piNumbers.length - 1;
    }
    int index = 0;
    List<String> numbers =
        piNumbers.substring(0, this.maxNumbersToRender).split('');
    return numbers.map((String number) {
      var testSpan = TextSpan(
          text: (index + 1) % 6 == 0 ? '$number\n' : number,
          style: TextStyle(
            fontSize: 60.0,
            letterSpacing: 8.0,
            background: Paint()..color = (index == topResults) && index != 0 ? Colors.blue : Colors.black,
            decorationStyle: TextDecorationStyle.wavy,
            decorationColor: Colors.blue,
            decoration: index >= this.streakStart && index <= this.streakEnd && this.streakStart != this.streakEnd
                ? TextDecoration.underline
                : TextDecoration.none,
          ));
      index += 1;
      return testSpan;
    }).toList();
  }

  void onViewMore() {
    setState(() {
      this.maxNumbersToRender = this.maxNumbersToRender * 2;
    });
  }

  void decreaseFontSize() {}

  void increaseFontSize() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HELP'),
          actions: <Widget>[
            FlatButton(
              child: Text('LOAD MORE', style: TextStyle(color: Colors.white)),
              onPressed: onViewMore,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                          text: '3.\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 120.0,
                        ),
                      children: this.getNumbersToRender()),
                    )
                  )
                )
              )
            )
          ],
        )
      );
  }
}
