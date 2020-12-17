import 'package:flutter/material.dart';

class Style{
   final adminInputDecoration = InputDecoration(
    labelText: 'Введите логин:',
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue[700]),
        borderRadius: BorderRadius.all(Radius.circular(25))),
  );
  final adminPasswrodStyle = InputDecoration(
    labelText: 'Введите пароль:',
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue[700]),
        borderRadius: BorderRadius.all(Radius.circular(25))),
  );
    final loginButtonStyle = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
      side: BorderSide(color: Colors.white));
}