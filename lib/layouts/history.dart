import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:qrcodescanner/api/api.dart';
import 'package:qrcodescanner/models/infoModel.dart';


  DateTime start;
  DateTime end;

  class HistoryPage extends StatefulWidget {
  
    @override
    _HistoryPageState createState() => _HistoryPageState();
  }

class _HistoryPageState extends State<HistoryPage> {
  var _list;
  var api = Api();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: api.fetchInfoData(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _list = snapshot.data;
            print('_list: $_list');
            return Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Colors.blue[400],
                          child: Text('Дата начала'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2021))
                                .then((value) {
                              start = value;
                              setState(() {
                        _list = start;
                      });
                            });
                          }),
                      RaisedButton(
                        color: Colors.blue[400],
                          child: Text('Дата конца'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2021))
                                .then((value) {
                              end = value;
                              setState(() {
                                _list = end;
                              });
                            });
                          })
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: monthInfo(_list[index].date),
                                  subtitle: Text(
                                      getDatesString(_list[index])),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: _list.length),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget monthInfo(date) {
    int month = date.month;
    List<String> months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    Widget result =
        Text(formatDate(date, [dd, ' - ', months[month - 1], ' - ', yyyy]));
    return result;
  }

  String getDatesString(InfoModel info) {
    String incoming = formatDate(info.incoming, [HH, ':', nn]);
    String outcoming = (info.outcoming == '')
        ? '--'
        : formatDate(info.outcoming, [HH, ':', nn]);
    return 'Время прихода: $incoming --  Время ухода: $outcoming';
  }
}
