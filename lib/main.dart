import 'package:flutter/material.dart';
import 'package:flutter_network/network.dart';

void main() {
  runApp(const NetworkApp());
}

class NetworkApp extends StatelessWidget {
  const NetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NetworkScreen(),
    );
  }
}

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    // Start of app
    super.initState();
    futureAlbum = fetchAlbum(); // Fetch album async to be used later
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Album",
          style: style,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    style: style,
                    snapshot.data!.title,
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    style: style,
                    '${snapshot.error}',
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
