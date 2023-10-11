import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      },
  );

  if (response.statusCode == 200) {
    // OK
    return Album.fromJson(jsonDecode(response.body));
  }

  throw Exception('Failed to load album');
}

Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'title': title
    }),
  );

  if (response.statusCode == 201) {
    // Created
    return Album.fromJson(jsonDecode(response.body));
  }

  throw Exception("Failed to create album");
}

Future<Album> updateAlbum(String title) async {
  final http.Response response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'title': title
    }),
  );

  if (response.statusCode == 200) {
    // OK
    return Album.fromJson(jsonDecode(response.body));
  }

  throw Exception("Failed to update album");
}

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json["id"], title: json["title"]);
  }
}