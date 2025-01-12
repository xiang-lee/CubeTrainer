import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class C2F2LWidget extends StatefulWidget {
  @override
  _C2F2LWidgetState createState() => _C2F2LWidgetState();
}

class _C2F2LWidgetState extends State<C2F2LWidget> {
  int _selectedLevel = 0;
  List<List<String>> scrambles = [];
  List<String> levels = [
    'Level 1 - Cross requires 1 move to solve',
    'Level 2 - Cross requires 2 move to solve',
    'Level 3 - Cross requires 3 move to solve',
    'Level 4 - Cross requires 4 move to solve',
    'Level 5 - Cross requires 5 move to solve',
    'Level 6 - Cross requires 6 move to solve',
    'Level 7 - Cross requires 7 move to solve',
    'Level 8 - Cross requires 8 move to solve',
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

  @override
  Widget build(BuildContext context) {
    print('Building C2F2LWidget'); // Debug print
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
            print('Get Scramble button pressed'); // Debug print
            print('Current selected level: \$_selectedLevel');
            // Fetch and display scramble
            String scramble = scrambles[_selectedLevel][0]; // Example: get the first scramble
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