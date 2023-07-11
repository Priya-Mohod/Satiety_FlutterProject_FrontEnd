import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Service {
  Future<http.Response> saveFoodDetails(
    String freeFoodName,
    String freeFoodDescription,
    int freeFoodQuantity,
    String freeFoodAddress,
    String freeFoodImageUrl,
  ) async {
    var url = Uri.parse('http://192.168.0.70:8080/addfood');
    Map<String, String> headers = {"Content-type": "application/json"};
    Map data = {
      'freeFoodName': '$freeFoodName',
      'freeFoodDescription': '$freeFoodDescription',
      'freeFoodQuantity': '$freeFoodQuantity',
      'freeFoodAddress': '$freeFoodAddress',
      'freeFoodImageUrl': '$freeFoodImageUrl',
    };

    var body = json.encode(data);
    var response = await http.post(url, headers: headers, body: body);

    print("${response.body}");
    return response;
  }
}
