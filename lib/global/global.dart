
import 'dart:convert';

import 'package:http/http.dart' as http;
class Global{

  static String? userId;
  static String? userFirstName;
  static String? userLastName;
  static String? userEmail;
  static String? userImagePath;
  static String? token ;

 static var BASE_URL ="https://quizz-app-backend-3ywc.onrender.com/";


 // static Future<http.Response> get(String url, Map<String, String> query) async{
 //   var client = http.Client();
 //   var tmp_url = BASE_URL + url + Uri.https("", "", query).query;
 //   Uri uri = Uri.parse(tmp_url);
 //   var data = await client.get(uri, headers: {
 //   'Content-Type': 'application/json',
 //   "Authorization": "Bearer ${token}"
 //   });
 //   return data;
 // }


  // static Future<http.Response> post(String url, Map<String, dynamic> body, {bool is_json = false}) async{
  //   var client = http.Client();
  //   var tmp_url = BASE_URL + url;
  //   var headers =  {
  //     'Content-Type': 'application/json',
  //     "Authorization": "Bearer ${token}"
  //   };
  //   Uri uri = Uri.parse(tmp_url);
  //   var data = is_json
  //       ? await client.post(uri , headers: headers, body: json.encode(body))
  //       : await client.post(uri , headers: headers, body: body);
  //   return data;
  // }


}