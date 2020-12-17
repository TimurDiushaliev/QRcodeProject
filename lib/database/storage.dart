import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrcodescanner/api/api.dart';

class Storage {
  final storage = FlutterSecureStorage();

  Future writeSecureData(String key, String value) async {
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }

  Future readSecureData(String key) async {
    var readData = await storage.read(key: key);
    return readData;
  }

  Future readAllSecureData() async {
    var writeAllData = await storage.readAll();
    return writeAllData;
  }

  Future deleteAllSecureData() async {
    var deleteData = await storage.deleteAll();
    return deleteData;
  }

  Future containsData(String key) async {
    var result = await storage.containsKey(key: key);
    return result;
  }

  Future checkToken() async {
    var token = await readSecureData('token');
    if (token != null) headers['Authorization'] = 'Token $token';
  }
}
