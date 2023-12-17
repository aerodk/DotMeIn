import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.black; // Initial color

  // Define a 2D list to hold cell colors
  List<List<Color>> gridColors = List.generate(
    8,
    (index) => List.generate(8, (index) => Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Fill'),
      ),
      body: Column(
        children: [
          SimpleColorPicker(
            selectedColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, // Justér antallet af kolonner efter behov
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 8; // Beregner rækken baseret på indekset
                int col = index % 8; // Beregner kolonnen baseret på indekset

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Ændrer farven på den trykkede celle til den valgte farve
                      gridColors[row][col] = selectedColor;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    color: gridColors[row][col],
                  ),
                );
              },
              itemCount: gridColors.length * gridColors[0].length,
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  SimpleColorPicker(
      {required this.selectedColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ColorCircle(Colors.black, onColorChanged, selectedColor),
        _ColorCircle(Colors.white, onColorChanged, selectedColor),
        _ColorCircle(Colors.red, onColorChanged, selectedColor),
        _ColorCircle(Colors.green, onColorChanged, selectedColor),
        _ColorCircle(Colors.blue, onColorChanged, selectedColor),
        _ColorCircle(Colors.yellow, onColorChanged, selectedColor),
        _ColorCircle(Colors.purple, onColorChanged, selectedColor),
        _ColorCircle(Colors.orange, onColorChanged, selectedColor),
        _ColorCircle(Colors.pink, onColorChanged, selectedColor),
      ],
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;
  final Color selectedColor;

  _ColorCircle(this.color, this.onColorChanged, this.selectedColor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorChanged(color);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selectedColor == color
                ? selectedColor == Colors.black
                    ? Colors.grey
                    : Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
