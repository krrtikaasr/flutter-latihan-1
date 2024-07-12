import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'CameraPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _navigateToPermissionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PermissionsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _navigateToPermissionsPage,
              child: const Text('Go to Permissions Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _cameraPermission = false;
  bool _locationPermission = false;
  bool _microphonePermission = false;

  void _showCameraSuggestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suggestion'),
          content: const Text(
              'You have enabled camera permission. Do you want to open the camera now?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Camera'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Camera Permission'),
            value: _cameraPermission,
            onChanged: (bool value) {
              if (value) {
                requestCameraPermission();
              } else {
                setState(() {
                  _cameraPermission = false;
                });
              }
            },
          ),
          SwitchListTile(
            title: const Text('Location Permission'),
            value: _locationPermission,
            onChanged: (bool value) {
              setState(() {
                _locationPermission = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Microphone Permission'),
            value: _microphonePermission,
            onChanged: (bool value) {
              setState(() {
                _microphonePermission = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      setState(() {
        _cameraPermission = true;
      });
      _showCameraSuggestion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Camera permission is required.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
