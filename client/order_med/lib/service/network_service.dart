import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:order_med/globals.dart' as globals;

class NetworkService {
  static NetworkService? _instance;
  // Avoid self instance
  NetworkService._();
  static NetworkService get instance {
    _instance ??= NetworkService._();
    return _instance!;
  }

  String baseUrl = setBaseAddress();

  static Future<String> getIPAddress() async {
    return (await NetworkInterface.list())
        .singleWhere((interface) => interface.name == 'WiFi')
        .addresses
        .singleWhere((address) => address.type == InternetAddressType.IPv4)
        .address;
  }

  static setBaseAddress() async {
    String ip = await getIPAddress();
    globals.baseUrl = 'http://$ip:3000';
    return globals.baseUrl;
  }

  static Future<dynamic> fetch(String path, {Object? body, File? image}) async {
    final uri = Uri.parse(globals.baseUrl + path);
    var headers = <String, String>{
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8'
    };
    http.Response response;
    if (body == null) {
      print('GET  \t $uri');
      response = await http.get(uri, headers: headers);
    } else {
      print('POST  \t $uri');
      response = await http.post(uri, headers: headers, body: jsonEncode(body));
    }
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to fetch');
    }
  }

  static Future<String> uploadImage(File image) async {
    final uri = Uri.parse('${globals.baseUrl}/order/uploadPrescription');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes(
        'image', image.readAsBytesSync(),
        filename: image.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      return str;
    } else {
      print(response.reasonPhrase);
      throw 'Failed to Upload';
    }
  }
}
