import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcodescanner/api/api.dart';
import 'package:qrcodescanner/database/storage.dart';
import 'package:qrcodescanner/layouts/history.dart';
import 'package:qrcodescanner/layouts/qrcodescanner.dart';
import 'package:toast/toast.dart';
import '../main.dart';

final storage = Storage();

class SecondScreen extends StatefulWidget {
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");
  var scanResult;
  String qrValue = 'test123';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.readAllSecureData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            // print(snapshot);
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data['username']),
                centerTitle: true,
              ),
              drawer: Drawer(
                  child: ListView(
                children: [
                  DrawerHeader(
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.history),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HistoryPage()));
                            },
                            title: Text('История'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.exit_to_app),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                storage.deleteAllSecureData();
                                headers.remove('Authorization');
                                passwordController.clear();
                                return MainScreen();
                              }), (route) => false);
                            },
                            title: Text('Выйти'),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
              body: Center(
                child: LayoutBuilder(
                  builder: (context, constaints) {
                    return IconButton(
                        icon: Icon(Icons.camera),
                        // color: Colors.blue,
                        iconSize: constaints.maxHeight * 0.15,
                        onPressed: () {
                          scan();
                        });
                  },
                ),
              ),
              // Text(scanResult.rawContent)
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() => scanResult = result);
      if (scanResult.rawContent == qrValue) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WaitingPage()));
      } else {
        Toast.show('Неверный QR-код, попробуйте заново', context);
      }
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent =
              'Для работы приложения необходимо разрешить доступ к камере';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }
}
