import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcodescanner/api/api.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'alreadyDone.dart';
import 'error.dart';
import 'incoming.dart';

class WaitingPage extends StatefulWidget {
  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() { 
    super.initState();
    Future<http.Response> sendRequest() async {
          try {
            final apiUrl = baseUrl + 'timecontrol/';
            final response = await http.get(apiUrl, headers: headers);
            return response;
          } on TimeoutException catch (e) {
            Toast.show(
                'Вышло время ожидания, проверьте интернет подключение', context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            print('Timeout Error: $e');
          } on SocketException catch (e) {
            Toast.show(
                'Связь с сервером прервана, проверьте интернет подключение',
                context,
                gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG);
            print('Socket Error: $e');
          } on Error catch (e) {
            print('General Error: $e');
          }
        }

        Future<http.Response> sendPostRequest(body) async {
          try {
            final apiUrl = baseUrl + 'timecontrol/';
            final response = await http.post(apiUrl,
                headers: headers, body: json.encode(body));
            return response;
          } on TimeoutException catch (e) {
            Toast.show(
                'Вышло время ожидания, проверьте интернет подключение', context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            print('Timeout Error: $e');
          } on SocketException catch (e) {
            Toast.show(
                'Связь с сервером прервана, проверьте интернет подключение',
                context,
                gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG);
            print('Socket Error: $e');
          } on Error catch (e) {
            print('General Error: $e');
          }
        }

        try {
          sendRequest().then((response) {
            if (response.statusCode == 200) {
              var body = json.decode(response.body);
              print(body);
              if (body['value'] != false) {
                sendPostRequest(body).then((res) {
                  if (res.statusCode == 200) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IncomingPageState(text: body['value'])));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ErrorPage()));
                  }
                });
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AlreadyDone()));
              }
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ErrorPage()));
            }
          });
        } catch (e) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ErrorPage()));
        }
        
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
          body: Center(
         child: CircularProgressIndicator(),
      ),
    );
  }
}
