import 'package:flutter/material.dart';

import './pages/training/training.dart';
import './pages/references/references.dart';
import './pages/statistics/statistics.dart';

void main() => runApp(MaterialApp(
        theme: new ThemeData(
            primaryColor: Colors.black,
            backgroundColor: Colors.black,
            scaffoldBackgroundColor: Colors.black),
        initialRoute: '/',
        routes: {
          '/': (context) => SelectPage(),
          '/references': (context) => References(),
          '/training': (context) => Training(),
          '/statistics': (context) => Statistics()
        }));

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.black,
            child: FlatButton(
                child: Text('HELP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.0,
                        fontWeight: FontWeight.w300)),
                onPressed: () {
                  Navigator.pushNamed(context, '/references');
                }),
          ),
        ),
        Container(
          color: Colors.black,
          height: 100.0,
          child: FlatButton(
              child: Text('STATISTICS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w300)),
              onPressed: () {
                Navigator.pushNamed(context, '/statistics');
              }),
        ),
        Expanded(
            child: Container(
          constraints: const BoxConstraints.expand(),
          child: FlatButton(
            child: Text('GO!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w300)),
            onPressed: () {
              Navigator.pushNamed(context, '/training');
            },
          ),
        ))
      ],
    ));
  }
}
