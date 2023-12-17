import 'package:flutter/foundation.dart';
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
  Color base = Colors.grey;
  static int rowCount = 12;
  static int colCount = 12;

  // Define a 2D list to hold cell colors
  List<List<Color>> gridColors = List.generate(
    rowCount,
    (index) => List.generate(colCount, (index) => Colors.grey),
  );

  // Define a 2D list to hold correct pattern colors
  List<List<Color>> correctPattern = List.generate(
    rowCount,
    (row) => List.generate(colCount,
        (col) => (row + col).isEven ? Colors.grey : Colors.white),
  );

  // Define a 2D list to hold whether each cell is correct or not
  List<List<bool>> correctness = List.generate(
    rowCount,
    (index) => List.generate(colCount, (index) => true),
  );

  bool compareActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Fill'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              buildColorPicker(),
              buildPreview(),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  compareActive = !compareActive;
                  if(compareActive) {
                    comparePatterns();
                  } else {
                    correctness = List.generate(rowCount, (index) => List.generate(colCount, (index) => true));
                    setState(() {
                    });
                  }
                },
                child: Text('Sammenlign mønstre'),
              )
            ],
          ),
          buildDotBox(),
        ],
      ),
    );
  }

  SimpleColorPicker buildColorPicker() {
    return SimpleColorPicker(
      selectedColor: selectedColor,
      onColorChanged: (color) {
        setState(() {
          selectedColor = color;
        });
      },
    );
  }

  Expanded buildDotBox() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: colCount, // Justér antallet af kolonner efter behov
        ),
        itemBuilder: (context, index) {
          int row = index ~/ colCount; // Beregner rækken baseret på indekset
          int col = index % colCount; // Beregner kolonnen baseret på indekset

          return GestureDetector(
            onTap: () {
              setState(() {
                // Ændrer farven på den trykkede celle til den valgte farve
                if (gridColors[row][col] == selectedColor) {
                  gridColors[row][col] = base;
                } else {
                  gridColors[row][col] = selectedColor;
                }
              });
            },
            child:
            Container(
              margin: EdgeInsets.all(2),
              color: gridColors[row][col],
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: gridColors[row][col],
                  border: !correctness[row][col]
                      ? Border.all(
                    color: Colors.red, // Farven på den røde ramme
                    width: 2.0, // Bredden på den røde ramme
                  )
                      : null, // Ingen ramme, hvis farven matcher
                ),
              )
            )
          );
        },
        itemCount: colCount * rowCount,
      ),
    );
  }

  Widget buildPreview() {
    double previewHeight = MediaQuery.of(context).size.height * 0.33;
    double previewWidth = MediaQuery.of(context).size.width * 0.33;

    return Container(
      height: previewHeight,
      width: previewWidth,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: colCount,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ colCount;
          int col = index % colCount;

          // Color patternColor = (row + col).isEven ? Colors.grey : Colors.white;

          return Container(
            width: previewWidth / colCount,
            height: previewHeight / rowCount,
            color: correctPattern[row][col],
          );
        },
        itemCount: rowCount * colCount,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  void comparePatterns() {
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < colCount; col++) {
        correctness[row][col] =
            gridColors[row][col] == correctPattern[row][col];
        if (kDebugMode) {
          print('$row $col is ${correctness[row][col]}');
        }
      }
    }
    setState(() {});
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
