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
  final TextEditingController _controller = TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    // Start of app
    super.initState();
    _futureAlbum = fetchAlbum(); // Get album
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28);

    return Scaffold(
      // Body
      body: Container(
        alignment: Alignment.center,
        // Future
        child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // Success
                  // Column
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // C1
                        Text(
                          'Fetched Album:',
                          style: style,
                        ),

                        // C2
                        Text(
                          snapshot.data?.title ?? 'Deleted',
                          style: style,
                        ),

                        // C3
                        const SizedBox(
                          height: 100,
                        ),

                        // C4
                        TextField(
                          controller: _controller,
                          decoration:
                              // Edit text
                              InputDecoration(
                                  hintText: 'Enter Title', hintStyle: style),
                        ),

                        // C5
                        ElevatedButton(
                          onPressed: () {
                            // On click
                            setState(() {
                              _futureAlbum = updateAlbum(_controller.text);
                            });
                          },
                          child: Text(
                            'Update Album',
                            style: style,
                          ),
                        ),

                        // C6
                        ElevatedButton(
                          onPressed: () {
                            // On click
                            setState(() {
                              _futureAlbum =
                                  deleteAlbum(snapshot.data!.id.toString());
                            });
                          },
                          child: Text(
                            'Delete Album',
                            style: style,
                          ),
                        ),
                      ]);
                } else if (snapshot.hasError) {
                  // Error
                  return Text(
                    '${snapshot.error}',
                    style: style,
                  );
                }
              }
              // Loading
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
