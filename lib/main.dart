import 'package:flutter/material.dart';
import 'package:cube_trainer/Metronome.dart';
import 'package:cube_trainer/C2F2L.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube Trainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cube Trainer'),
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
  int _selectedIndex = 0;

  final GlobalKey<MetronomeWidgetState> _metronomeKey = GlobalKey<MetronomeWidgetState>();
  
  late final List<Widget> _widgetOptions; // 使用 late 关键字

  _MyHomePageState() {
    _widgetOptions = [
      MetronomeWidget(key: _metronomeKey),
      C2F2LWidget(),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) { // 只在选项变化时执行
      if (index != 0) { // Switching away from Metronome
        _metronomeKey.currentState?.stopMetronomeExternally();
      }
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cube Trainer', style: TextStyle(fontSize: 28)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           Padding(
              padding: const EdgeInsets.only(top: 40.0), // 调整 C2F2LWidget 顶部边距
              child: C2F2LWidget(),
            ),
            SizedBox(height: 80), // 增加 C2F2LWidget 和 MetronomeWidget 之间的距离
            MetronomeWidget(key: _metronomeKey), // 确保传递 GlobalKey
          ],
        ),
      ),
    );
  }
}