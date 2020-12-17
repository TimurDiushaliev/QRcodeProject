import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomingPageState extends StatelessWidget {
  final text;

  IncomingPageState({Key key, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var a = text == 'incoming' ? 'приход' : 'уход';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/tick.svg'),
                Text('Вы выполнили: $a')
              ],
            ),
          ),
        ),
      ),
    );
  }
}