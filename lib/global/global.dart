import 'dart:convert';

import 'package:http/http.dart' as http;
class Global{

  static String? userId;

 static var BASE_URL ="https://quizz-app-backend-3ywc.onrender.com/";

 static Future<http.Response> get(String url, Map<String, String> query) async{
   var client = http.Client();
   var tmp_url = BASE_URL + url + Uri.https("", "", query).query;
   Uri uri = Uri.parse(tmp_url);
   var data = await client.get(uri, headers: {
   'Content-Type': 'application/json',
   "Authorization":
   "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzM1NjE5OSwiZXhwIjoxNzI3Mzg0OTk5fQ.FVWQRHz5MBpng_NAmufk-tRREgiDa4jtrZrohVZ4sLk"
   });
   return data;
 }

 static Future<http.Response> post(String url, Map<String, dynamic> body,{bool is_json = false}) async{
   var client = http.Client();
   String tmp_url;
   if (is_json)
     tmp_url = BASE_URL + url;
   else
     tmp_url = BASE_URL + url;
   var headers = {
     "Authorization":
     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NmVkMDczZWQxNjI4OGIxMzBiMjczODgiLCJmaXJzdF9uYW1lIjoiSXNoaXRhICIsImxhc3RfbmFtZSI6InBvc2hpeWEgIiwiZW1haWxfaWQiOiJpc2hpdGFwb3NoaXlhMTgxMUBnbWFpbC5jb20iLCJfX3YiOjAsImlhdCI6MTcyNzM1NjE5OSwiZXhwIjoxNzI3Mzg0OTk5fQ.FVWQRHz5MBpng_NAmufk-tRREgiDa4jtrZrohVZ4sLk"
   };
   if(is_json) headers.addAll({"Content-Type": "application/json"});
   Uri uri = Uri.parse(tmp_url);
   var data = is_json
       ? await client.post(uri , headers: headers, body: json.encode(body))
       : await client.post(uri , headers: headers, body: body);
   return data;
 }

}