import 'dart:convert';

import 'package:http/http.dart';

import '../model/post_model.dart';

const baseUrl = 'https://jsonplaceholder.typicode.com/posts/';

class MyApiClient {
  final Client httpClient;

  MyApiClient({required this.httpClient});

  getAll() async {
    try {
      var response = await httpClient.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        List<PostModel> listMyModel = jsonResponse.map((model) => PostModel.fromJson(model)).toList();
        return listMyModel;
      } else {
        throw 'Response.statusCode: ${response.statusCode}';
      }
    } catch (_) {}
  }
}
