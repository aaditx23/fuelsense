import 'package:flutter_dotenv/flutter_dotenv.dart';

String urlEncodeBody(Map<String, dynamic> json){
  return json.keys
      .map(
        (key) =>
    "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(json[key]!)}",
  )
      .join("&");
}

final baseUrl = dotenv.env['API_BASE_URL'];