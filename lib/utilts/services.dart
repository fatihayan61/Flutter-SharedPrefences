import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dataModel.dart';

class Service {
  String url = "https://jsonplaceholder.typicode.com/posts";
  late final http.Response response;
  Future<List<Post>> fetchData(http.Client client) async {
    response = await client.get(Uri.parse(url));
    // SharedPrefs().createDataShared(response.body);
    return parseData(response.body);
  }

  List<Post> parseData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }
}
