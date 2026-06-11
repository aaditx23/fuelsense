import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String urlEncodeBody(Map<String, dynamic> json){
  return json.keys
      .map(
        (key) =>
    "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(json[key]!)}",
  )
      .join("&");
}

final baseUrl = dotenv.env['API_BASE_URL'];

Future<bool> hasConnection() async{
  try{
    final response = await http.get(Uri.parse(dotenv.env['HEALTH_URL']!)).timeout(const Duration(seconds: 60));

    return response.statusCode == 200;
  }
  catch(e){
    return false;
  }
}