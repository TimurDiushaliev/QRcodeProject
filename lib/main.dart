import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrcodescanner/database/storage.dart';
import 'package:qrcodescanner/layouts/secondScreen.dart';
import 'package:qrcodescanner/styles/style.dart';
import 'package:toast/toast.dart';

import 'api/api.dart';

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

bool loginResult = false;
bool connectionState = false;
BuildContext dialogContext;
TextEditingController passwordController = TextEditingController();

showAlertDialog(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(),
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Text('Подождите...'),
      )
    ]),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alertDialog;
      });
}

Future createUser(String name, String password, context) async {
  final String apiUrl = baseUrl + 'auth/token/login/';
  final body = {'username': name, 'password': password};
  try {
    final response =
        await http.post(apiUrl, headers: headers, body: json.encode(body));
    connectionState = true;
    print('body: ${json.decode(response.body)}');
    if (response.statusCode == 200) {
      final Map responseBody = json.decode(response.body);
      var token = responseBody['auth_token'];
      await storage.writeSecureData('token', token);
      headers['Authorization'] = 'Token $token';
      print('1: ${headers['Authorization']}');
      loginResult = true;
      connectionState = true;
      // _insert(name, password);
    } else
      loginResult = false;
  } on TimeoutException catch (e) {
    Toast.show('Вышло время ожидания, проверьте интернет подключение', context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    print('Timeout Error: $e');
    connectionState = false;
    // 
    
  } on SocketException catch (e) {
    Toast.show(
        'Связь с сервером прервана, проверьте интернет подключение', context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    print('Socket Error: $e');
    connectionState = false;
    // Navigator.pop(dialogContext);
  } on Error catch (e) {
    connectionState = false;
    print('General Error: $e');
    // Navigator.pop(dialogContext);
  }
}

Future onPressed(context) async {
  String _username = nameController.text;
  String _userpassword = passwordController.text;
  if (_username.isNotEmpty && _userpassword.isNotEmpty) {
    showAlertDialog(context);
    await storage.writeSecureData('username', _username);
    await storage.writeSecureData('userpassword', _userpassword);
    await createUser(_username, _userpassword, context);
    if (connectionState) {
      if (loginResult) {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => SecondScreen()))
            .then((value) {
          Navigator.pop(dialogContext);
          passwordController.clear();
        });
      } else {
        Toast.show('Такого пользователя не существует', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  } else {
    Toast.show('Введите логин и пароль', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
  Navigator.pop(dialogContext);
}

// this allows us to access the TextField text
TextEditingController nameController = TextEditingController();

//Instances
final style = Style();
final storage = Storage();

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: storage.readSecureData('token'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print('snap data: ${snapshot.data}');
          if (snapshot.data == null) {
            return MaterialApp(
              home: Scaffold(
                // appBar: AppBar(
                //   title: Text('Кюер'),
                // ),
                body: Container(
                  height: _height * 1,
                  width: _width * 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.3,
                                bottom: constraints.maxHeight * 0.05,
                                left: constraints.maxWidth * 0.05,
                                right: constraints.maxWidth * 0.05),
                            child: TextField(
                                controller: nameController,
                                decoration: style.adminInputDecoration),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: constraints.maxWidth * 0.05,
                                right: constraints.maxWidth * 0.05),
                            child: TextField(
                                controller: passwordController,
                                decoration: style.adminPasswrodStyle),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: constraints.maxHeight * 0.07),
                            child: RaisedButton(
                              color: Colors.blue,
                              padding: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.03,
                                  bottom: constraints.maxHeight * 0.03,
                                  left: constraints.maxWidth * 0.38,
                                  right: constraints.maxWidth * 0.38),
                              shape: style.loginButtonStyle,
                              child: Text(
                                'ВОЙТИ',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                onPressed(context);
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            headers['Authorization'] = 'Token ${snapshot.data}';
            print('2: $headers');
            return SecondScreen();
          }
        });
  }
}

// void _insert(name, password) async {
//   // row to insert
//   Map<String, dynamic> row = {
//     DataBaseHelper.columnName: name,
//     DataBaseHelper.columnPassword: password,
//   };
//   dbHelper.deleteAllRows(DataBaseHelper.table);
//   final id = await dbHelper.insert(row);
//   print('inserted row id: $id');
//   print('inserted row name: $name');
//   print('inserted row name: $password');
// }
