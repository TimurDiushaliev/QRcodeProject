import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: SvgPicture.asset('assets/images/cancel.svg'),
            ),
            Text('Что-то пошло не так', style: TextStyle(fontSize: 24),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}