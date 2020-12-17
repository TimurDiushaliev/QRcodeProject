import 'package:flutter/material.dart';

class AlreadyDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
          body: Center(
          child: Text(
            'Вы уже выполнили приход и уход за сегодня',
            style: TextStyle(fontSize: 24.0),
        ),
      )),
    );
  }
}