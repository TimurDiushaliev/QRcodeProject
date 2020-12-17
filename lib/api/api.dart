import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrcodescanner/layouts/history.dart';
import 'package:qrcodescanner/models/infoModel.dart';
import 'package:toast/toast.dart';

final String baseUrl = 'http://timeset.pythonanywhere.com/api/v1/';
var headers = {'Content-type': 'application/json; charset=Utf-8'};

class Api {
  BuildContext dialogContext;
  // showAlertDialog(BuildContext context) {
  //   AlertDialog alertDialog = AlertDialog(
  //     content: Row(children: [
  //       CircularProgressIndicator(),
  //       Container(
  //         margin: EdgeInsets.only(left: 10),
  //         child: Text('Подождите...'),
  //       )
  //     ]),
  //   );
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         dialogContext = context;
  //         return alertDialog;
  //       });
  //   Navigator.pop(dialogContext);
  // }

  // Future<List<ProfileModel>> fetchDataFromJson() async {
  //   final apiUrl = baseUrl + 'timecontrol/list/';
  //   var response = await http.get(
  //     apiUrl,
  //     headers: headers,
  //   );
  //   var persons = List<ProfileModel>();
  //   if (response.statusCode == 200) {
  //     var personsJson = json.decode(response.body);
  //     print(personsJson);
  //     for (var person in personsJson) {
  //       persons.add(ProfileModel.fromJson(person));
  //     }
  //   } else {
  //     print('headers: $headers');
  //     print(json.decode(response.body));
  //   }
  //   return persons;
  // }

  Future fetchInfoData(context) async {
    try{
    var startDate = start==null ?DateTime.now().subtract(new Duration(days: 7)).toLocal(): start;
    var endDate = end ==null? DateTime.now().toLocal(): end;
    var queryParameters = {
      'start_date': "${startDate.year}-${startDate.month}-${startDate.day}",
      'end_date': "${endDate.year}-${endDate.month}-${endDate.day}"
    };
    var url = Uri.http('timeset.pythonanywhere.com',
        '/api/v1/timecontrol/list/', queryParameters);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var infoList = infoModelFromJson(response.body);
      return infoList;
    }
    }  on TimeoutException catch (e) {
      Toast.show(
          'Вышло время ожидания, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      Toast.show(
          'Связь с сервером прервана, проверьте интернет подключение', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }
}
