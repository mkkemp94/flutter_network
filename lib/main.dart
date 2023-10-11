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
  late Future<Album> fetchedAlbum;
  final TextEditingController _controller = TextEditingController();
  Future<SimpleAlbum>? _futureSimpleAlbum;

  @override
  void initState() {
    // Start of app
    super.initState();
    fetchedAlbum = fetchAlbum(); // Get album
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28);

    return Scaffold(
      // Top bar
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Album",
          style: style,
        ),
      ),

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
            FutureBuilder<Album>(
              future: fetchedAlbum,
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

            // C3
            const SizedBox(
              height: 100,
            ),

            // C4
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(18),
              child: (_futureSimpleAlbum == null)
                  ? buildEnterAlbumSection(style)
                  : buildShowAlbumSection(style),
            ),
          ],
        ),
      ),
    );
  }

  Column buildEnterAlbumSection(TextStyle style) {
    final TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // C1
        TextField(
          controller: _controller,
          decoration:
              InputDecoration(hintText: 'Enter Title', hintStyle: style),
        ),

        // C2
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureSimpleAlbum = createSimpleAlbum(_controller.text);
              });
            },
            child: Text(
              'Create Album',
              style: style,
            )),
      ],
    );
  }

  Column buildShowAlbumSection(TextStyle style) {
    final TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(

            fontSize: 28);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // C1
        FutureBuilder<SimpleAlbum>(
            future: _futureSimpleAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(style: style, snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text(style: style, '${snapshot.error}');
              }

              return const CircularProgressIndicator();
            }),

        // C2
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureSimpleAlbum = null;
              });
            },
            child: Text(style: style, 'Reset Album')),
      ],
    );
  }
}
