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

      // Screen
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
  late Future<Album> _fetchedAlbum; // To get
  Future<Album>? _createdAlbum; // To create
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // Start of app
    super.initState();
    _fetchedAlbum = fetchAlbum(); // Get album
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28);

    return Scaffold(
      // Body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // C1
            Text(
              'Fetched Album:',
              style: style,
            ),

            // C2
            buildFetchedAlbumSection(style),

            // C3
            const SizedBox(
              height: 100,
            ),

            // C4
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(18),
              child: (_createdAlbum == null)
                  ? buildCreateAlbumSection(style)
                  : buildShowCreatedAlbumSection(style),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<Album> buildFetchedAlbumSection(TextStyle style) {
    return FutureBuilder<Album>(
      future: _fetchedAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            // Success
            snapshot.data!.title,
            style: style,
          );
        } else if (snapshot.hasError) {
          return Text(
            // Error
            '${snapshot.error}',
            style: style,
          );
        }
        // Loading
        return const CircularProgressIndicator();
      },
    );
  }

  Column buildCreateAlbumSection(TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // C1
        TextField(
          controller: _controller,
          decoration:
              // Edit text
              InputDecoration(hintText: 'Enter Title', hintStyle: style),
        ),

        // C2
        ElevatedButton(
            onPressed: () {
              // On click
              setState(() {
                _createdAlbum = createAlbum(_controller.text);
              });
            },
            child: Text(
              'Create Album',
              style: style,
            )),
      ],
    );
  }

  Column buildShowCreatedAlbumSection(TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // C1
        FutureBuilder<Album>(
            future: _createdAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Success
                return Text(style: style, snapshot.data!.title);
              } else if (snapshot.hasError) {
                // Error
                return Text(style: style, '${snapshot.error}');
              }
              // Loading
              return const CircularProgressIndicator();
            }),

        // C2
        ElevatedButton(
            onPressed: () {
              // On click
              setState(() {
                _createdAlbum = null;
              });
            },
            child: Text(style: style, 'Reset Album')),
      ],
    );
  }
}
