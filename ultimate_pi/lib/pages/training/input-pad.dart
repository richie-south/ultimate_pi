import 'package:flutter/material.dart';

class PadButton extends StatelessWidget {
  final void Function(String) onPress;
  final String textValue;
  final bool useSecondColor;
  final bool disabled;

  PadButton(
      {@required this.onPress,
      @required this.textValue,
      this.useSecondColor = false,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ButtonTheme(
      height: 100.0,
      child: FlatButton(
        shape: const StadiumBorder(),
        textColor: Colors.white,
        color: this.disabled ? Color.fromRGBO(33, 33, 33, 1.0) : Colors.black,
        child: Text(this.textValue,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400)),
        onPressed: () {
          if (!this.disabled) {
            this.onPress(this.textValue);
          }
        },
      ),
    ));
  }
}

class Pad extends StatelessWidget {
  final void Function(String) onPress;
  final bool disableClear;
  Pad({@required this.onPress, @required this.disableClear});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300.0,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                PadButton(
                  onPress: this.onPress,
                  textValue: '7',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '8',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '9',
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                PadButton(
                  onPress: this.onPress,
                  textValue: '4',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '5',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '6',
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                PadButton(
                  onPress: this.onPress,
                  textValue: '1',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '2',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: '3',
                ),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                PadButton(
                  onPress: this.onPress,
                  textValue: '0',
                ),
                PadButton(
                  onPress: this.onPress,
                  textValue: 'CLEAR',
                  useSecondColor: true,
                  disabled: this.disableClear,
                ),
              ],
            ))
          ],
        ));
  }
}
