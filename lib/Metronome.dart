import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomeWidget extends StatefulWidget {
  final GlobalKey<MetronomeWidgetState> key;

  MetronomeWidget({required this.key}) : super(key: key);

  void stopMetronomeExternally() {
    key.currentState?.stopMetronomeExternally();
  }

  @override
  MetronomeWidgetState createState() => MetronomeWidgetState();
}

class MetronomeWidgetState extends State<MetronomeWidget> {
  double _bpm = 60.0;
  Timer? _timer;
  final player = AudioPlayer();
  final cache = AudioCache(prefix: 'assets/sounds/');
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
      cache.play('metronome_click.wav');
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
          cache.play('metronome_click.wav');
        });
      }
    });
  }

  void stopMetronomeExternally() {
    if (_isPlaying) {
      _stopMetronome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _adjustSpeed(40),
                child: Text('40', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _adjustSpeed(70),
                child: Text('70', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _adjustSpeed(100),
                child: Text('100', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove, size: 30),
                onPressed: () {
                  _adjustSpeed(_bpm > 0 ? _bpm - 1 : 0);
                },
              ),
              Text('Speed: ${_bpm.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add, size: 30),
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
            onPressed: () {
              print('Metronome Start/Stop button pressed');
              _toggleMetronome();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPlaying ? Colors.red : Colors.green,
              minimumSize: Size(180, 70),
            ),
            child: Text(_isPlaying ? 'Stop' : 'Start',
                style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
} 