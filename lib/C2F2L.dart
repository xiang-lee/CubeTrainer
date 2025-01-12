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
    'Level 2 - 2 move to solve Cross',
    'Level 3 - 3 move to solve Cross',
    'Level 4 - 4 move to solve Cross',
    'Level 5 - 5 move to solve Cross',
    'Level 6 - 6 move to solve Cross',
    'Level 7 - 7 move to solve Cross',
    'Level 8 - 8 move to solve Cross',
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
        ElevatedButton(
          onPressed: () {
            // Fetch and display scramble
            String scramble = getRandomScramble(_selectedLevel); // Example: get the first scramble
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Scramble'),
                content: Text(scramble),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text('Get Scramble'),
        ),
      ],
    );
  }
} 