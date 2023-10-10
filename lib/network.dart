import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  // get() returns a [Future] that contains a [Response]
  final http.Response response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // OK
    return Album.fromJson(jsonDecode(response.body));
  }

  throw Exception('Failed to load album');
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json["userId"], id: json["id"], title: json["title"]);
  }
}