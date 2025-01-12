import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'dart:math';

class C2F2LWidget extends StatefulWidget {
  @override
  _C2F2LWidgetState createState() => _C2F2LWidgetState();
}

class _C2F2LWidgetState extends State<C2F2LWidget> {
  int _selectedLevel = 0;
  List<List<String>> scrambles = [];
  List<String> levels = [
    'Level 1 - 1 move to solve Cross',
    'Level 2 - 2 moves to solve Cross',
    'Level 3 - 3 moves to solve Cross',
    'Level 4 - 4 moves to solve Cross',
    'Level 5 - 5 moves to solve Cross',
    'Level 6 - 6 moves to solve Cross',
    'Level 7 - 7 moves to solve Cross',
    'Level 8 - 8 moves to solve Cross',
  ];
  String _scrambleResult = '';

  @override
  void initState() {
    super.initState();
    loadScrambles();
  }

  Future<void> loadScrambles() async {
    final String response = await rootBundle.loadString('assets/Scrambles.json');
    final data = await json.decode(response);
    setState(() {
      scrambles = List<List<String>>.from(data['scrambles'].map((x) => List<String>.from(x)));
    });
  }

  String getRandomScramble(int level) {
    final random = Random();
    if (scrambles.isNotEmpty && scrambles[level].isNotEmpty) {
      int randomIndex = random.nextInt(scrambles[level].length);
      return scrambles[level][randomIndex]; 
    }
    return ''; 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: _selectedLevel,
          items: List.generate(levels.length, (index) => DropdownMenuItem(
            value: index,
            child: Text(levels[index]),
          )),
          onChanged: (value) {
            setState(() {
              _selectedLevel = value!;
            });
          },
        ),
        SizedBox(height: 20), // 增加按钮与文本之间的间距
        // 使用条件渲染，只有在有 scramble 时才显示 Container
        if (_scrambleResult.isNotEmpty) 
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent, // 设置背景颜色
              borderRadius: BorderRadius.circular(8), // 设置圆角
            ),
            child: Text(
              _scrambleResult,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // 设置文本颜色
              ),
            ),
          ),
        SizedBox(height: 20), // 增加文本与按钮之间的间距
        ElevatedButton(
          onPressed: () {
            // Fetch and display scramble
            setState(() {
              _scrambleResult = getRandomScramble(_selectedLevel); // 获取随机 scramble
            });
          },
          child: Text('Get Scramble'),
        ),
      ],
    );
  }

} 