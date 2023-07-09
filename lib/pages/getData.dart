import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Data {
  Future getData() async {
    var url = Uri.parse('http://192.168.0.70:8080/getall');
    var response = await http.get(url);
    var data = json.decode(response.body);
    print('fetched: $data');
    return data;
  }
}
