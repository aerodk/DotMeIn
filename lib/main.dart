import 'package:dot_me_in/pattern_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.white54; // Initial color
  Color base = Colors.grey;
  int rowCount = 12;
  int colCount = 12;
  PatternService patternService = PatternService();
  PatternData selectedPatternData = PatternData([], 0, 0);

  // Define a 2D list to hold cell colors
  late List<List<Color>> gridColors;

  // Define a 2D list to hold whether each cell is correct or not
  late List<List<bool>> correctness;

  bool compareActive = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DotMeIn'),
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
                  if (compareActive) {
                    comparePatterns();
                  } else {
                    resetCompare();
                    setState(() {});
                  }
                },
                child: const Text('Sammenlign mønstre'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Åbn dialogen for at vælge mønster
                  showPatternDialog();
                },
                child: const Text('Vælg mønster'),
              )
            ],
          ),
          buildDotBox(),
        ],
      ),
    );
  }

  MyHomePageState() {
    // Initialize
    patternSelect(patternService.getPattern("Solen"));
    resetCompare();
  }

  List<List<bool>> resetCompare() {
    return correctness = List.generate(
        rowCount, (index) => List.generate(colCount, (index) => true));
  }

  void setPattern(PatternData patternData) {
    setState(() {
      patternSelect(patternData);
      // Opdater rowCount og colCount her, så de har de rigtige værdier
      rowCount = patternData.height;
      colCount = patternData.width;
      // Opdater gridColors og correctness med de nye rowCount og colCount
      gridColors = List.generate(
        rowCount,
        (index) => List.generate(colCount, (index) => Colors.grey),
      );
      correctness = resetCompare();
    });
  }

  void patternSelect(PatternData patternData) {
    rowCount = patternData.height;
    colCount = patternData.width;
    selectedPatternData = patternData;
    gridColors = List.generate(
      rowCount,
      (index) => List.generate(colCount, (index) => Colors.grey),
    );
  }

  void showPatternDialog() {
    List<String> availablePatterns = patternService.getAvailablePatterns();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Vælg mønster'),
          children: [
            for (String patternName in availablePatterns)
              ListTile(
                title: Text(patternName),
                onTap: () {
                  resetCompare();
                  setPattern(patternService.getPattern(patternName));
                  compareActive = false;
                  Navigator.pop(context);
                },
              ),
            // Tilføj eventuelle andre mønstre her
          ],
        );
      },
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
      child: GestureDetector(
        onTapDown: (details) {
          double scrollOffset = _scrollController.offset;
          double adjustedY = details.localPosition.dy + scrollOffset;

          // Beregn bredden af hver boks baseret på skærmens bredde og antallet af kolonner
          double boxWidth = MediaQuery.of(context).size.width / colCount;

          // Beregn rækkeindeks baseret på berøringens position
          int row = (adjustedY / boxWidth).floor();

          // Beregn kolonneindeks baseret på berøringens position
          int col = (details.localPosition.dx / boxWidth).floor();

          if (row >= 0 && row < rowCount && col >= 0 && col < colCount) {
            // Du kan nu bruge 'row' og 'col' til at identificere den trykkede boks
            // if (kDebugMode) {
            //   print('Box tapped at: $row, $col');
            // }
            setState(() {
              // Opdater farven på den berørte celle baseret på valgt farve
              if (gridColors[row][col] == selectedColor) {
                gridColors[row][col] = base;
              } else {
                gridColors[row][col] = selectedColor;
              }
            });
          }
        },
        onPanUpdate: (details) {
          compareActive = false;
          resetCompare();

          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition =
              renderBox.globalToLocal(details.globalPosition);

          // Beregn bredden af hver boks baseret på skærmens bredde og antallet af kolonner
          double boxWidth = MediaQuery.of(context).size.width / colCount;
// Adjust for scroll position
          double scrollOffset = _scrollController.offset;
          double adjustedY = details.localPosition.dy + scrollOffset;

// Beregn rækkeindeks baseret på berøringens position
          int row = (adjustedY / boxWidth).floor();

// Beregn kolonneindeks baseret på berøringens position
          int col = (localPosition.dx / boxWidth).floor();

          if (row >= 0 && row < rowCount && col >= 0 && col < colCount) {
            setState(() {
              // Opdater farven på den berørte celle baseret på valgt farve
              gridColors[row][col] = selectedColor;
            });
          }
        },
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colCount,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ colCount;
            int col = index % colCount;

            return Container(
              margin: const EdgeInsets.all(2),
              color: gridColors[row][col],
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: gridColors[row][col],
                  border: !correctness[row][col]
                      ? Border.all(
                          color: gridColors[row][col] == Colors.red
                              ? Colors.black12
                              : Colors.red,
                          width: 2.0,
                        )
                      : null,
                ),
              ),
            );
          },
          itemCount: colCount * rowCount,
        ),
      ),
    );
  }

  Widget buildPreview() {
    int width = selectedPatternData.width > 0 ? selectedPatternData.width : 1;
    int height =
        selectedPatternData.height > 0 ? selectedPatternData.height : 1;

    return SizedBox(
      height: height.toDouble() * 20.0,
      width: width.toDouble() * 20.0,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: width,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ width;
          int col = index % width;

          return Container(
            margin: const EdgeInsets.all(2),
            color: selectedPatternData.patternColors[row][col],
          );
        },
        itemCount: height * width,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  void comparePatterns() {
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < colCount; col++) {
        if (row < selectedPatternData.height &&
            col < selectedPatternData.width) {
          correctness[row][col] = gridColors[row][col] ==
              selectedPatternData.patternColors[row][col];
        } else {
          correctness[row][col] = false;
        }
      }
    }
    setState(() {});
  }
}

class SimpleColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const SimpleColorPicker(
      {super.key, required this.selectedColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ColorCircle(Colors.black, onColorChanged, selectedColor),
        _ColorCircle(Colors.white54, onColorChanged, selectedColor),
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

  const _ColorCircle(this.color, this.onColorChanged, this.selectedColor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorChanged(color);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
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
