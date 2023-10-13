import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';


class Stats extends StatelessWidget {
  final int data;
  final String title;

  Stats({
    required this.data,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(this.data.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 70.0
            )
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(this.title,
              style: TextStyle(
                color: Colors.white,
              )
            )
          )
        ],
      )
    );
  }
}


class Statistics extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _Statistics();
  }
}

class _Statistics extends State<Statistics> {
  int points = 0;
  int streak = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    getTotal();
    getStreak();
    getTopPoints();
  }

  void getTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topResult') ?? 0);
    setState(() {
      this.total = value;
    });
  }

  void getStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topStreak') ?? 0);
    setState(() {
      this.streak = value;
    });
  }

  void getTopPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('topPoints') ?? 0);
    setState(() {
      this.points = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          int total = this.total;
          int point = this.points;
          int combo = this.streak;
          Share.share('I know $total decimals of π!! and i got a score of $point with my longest combo $combo, crush my score here: https://goo.gl/J6YaVm');
        },
        child: new IconTheme(
          data: new IconThemeData(
            color: Colors.black
          ),
          child: new Icon(Icons.share),
        ),
      ),
      appBar: AppBar(
          title: Text('STATISTICS'),
        ),
      body: Container(
        child: Column(
        children: <Widget>[
          Expanded(
            child: Stats(
              data: this.points,
              title: 'POINTS',
            )
          ),
          Expanded(
            child: Stats(
              data: this.total,
              title: 'DECIMALS',
            )
          ),
          Expanded(
            child: Stats(
              data: this.streak,
              title: '️️️️️️️😍❗️️ LONGEST COMBO 👌🍌',
            ),
          ),
        ],
      ))
    );
  }
}
