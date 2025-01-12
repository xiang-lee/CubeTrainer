import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _bpm = 60.0;
  Timer? _timer;
  final player = SystemSound.play;
  bool _isPlaying = false;

  void _toggleMetronome() {
    if (_isPlaying) {
      _stopMetronome();
    } else {
      _startMetronome();
    }
  }

  void _startMetronome() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: (60000 / _bpm).round()), (timer) {
      player(SystemSoundType.click);
    });
    setState(() {
      _isPlaying = true;
    });
  }

  void _stopMetronome() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _adjustSpeed(double value) {
    setState(() {
      _bpm = value;
      if (_isPlaying) {
        _timer?.cancel();
        _timer = Timer.periodic(Duration(milliseconds: (60000 / _bpm).round()), (timer) {
          player(SystemSoundType.click);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cube Trainer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _adjustSpeed(_bpm > 0 ? _bpm - 1 : 0);
                  },
                ),
                Text('Speed: ${_bpm.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _adjustSpeed(_bpm < 200 ? _bpm + 1 : 200);
                  },
                ),
              ],
            ),
            Slider(
              value: _bpm,
              min: 0,
              max: 200,
              divisions: 200,
              label: _bpm.toStringAsFixed(0),
              onChanged: _adjustSpeed,
            ),
            ElevatedButton(
              onPressed: _toggleMetronome,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isPlaying ? Colors.red : Colors.green,
                minimumSize: Size(150, 60),
              ),
              child: Text(_isPlaying ? 'Stop' : 'Start',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
