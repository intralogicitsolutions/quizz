
import 'package:http/http.dart' as http;
class Global{

  static String? userId;
  static bool? score_update = false;
  static String? token ;

 static var BASE_URL ="https://quizz-app-backend-3ywc.onrender.com/";

 static Future<http.Response> get(String url, Map<String, String> query) async{
   var client = http.Client();
   var tmp_url = BASE_URL + url + Uri.https("", "", query).query;
   Uri uri = Uri.parse(tmp_url);
   var data = await client.get(uri, headers: {
   'Content-Type': 'application/json',
   "Authorization": "Bearer ${token}"
   });
   return data;
 }
}