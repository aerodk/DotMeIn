import 'dart:async';
import 'dart:math';

import 'package:dot_me_in/dialogs/share_dialog.dart';
import 'package:dot_me_in/encode_utils.dart';
import 'package:dot_me_in/pattern_service.dart';
import 'package:dot_me_in/star_widget.dart';
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

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool canPressButton = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  Color selectedColor = Colors.white54; // Initial color
  Color base = Colors.grey;
  int rowCount = 24;
  int colCount = 24;
  double maxCount = 64;
  double minCount = 6;
  PatternService patternService = PatternService();
  PatternData selectedPatternData = PatternData([], 0, 0, '');

  // Define a 2D list to hold cell colors
  late List<List<Color>> gridColors;

  // Define a 2D list to hold whether each cell is correct or not
  late List<List<bool>> correctness;

  bool compareActive = false;
  final ScrollController _scrollController = ScrollController();

  bool activateStar = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 2), // Juster varigheden efter dine præferencer
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DotMeIn'),
        actions: buildButtons(),
      ),
      body: Column(
        children: [
          buildDotBox(),
          Wrap(
            children: [
              notZen(selectedPatternData) ? buildPreview(selectedPatternData, 0.04) : buildZen(), // x % of screen size
              buildColorPicker(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildButtons() {
    final double iconSize = MediaQuery.of(context).size.width * 0.03;
    return [
      if (notZen(selectedPatternData))
        ElevatedButton(
          onPressed: () {
            compareActive = !compareActive;
            if (compareActive) {
              comparePatterns();
            } else {
              setState(() {
                resetCompare();
              });
            }
          },
          child: Icon(
            Icons.compare,
            size: iconSize,
          ),
        ),
      ElevatedButton(
        onPressed: () {
          // Open dialog for choosing pattern
          saveShare(context);
        },
        child: Icon(
          Icons.share_outlined,
          size: iconSize,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          // Open dialog for choosing pattern
          showPatternDialog();
        },
        child: Icon(
          Icons.arrow_forward_ios_outlined,
          size: iconSize,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            initGridColors();
            helpOut(selectedPatternData);
            compareForCorrect();
          });
        },
        child: Icon(Icons.cleaning_services, size: iconSize),
      ),
      if (notZen(selectedPatternData))
        ElevatedButton(
            onPressed: canPressButton ? handleButtonPress : null,
            child: Icon(Icons.help, size: iconSize))
    ];
  }

  bool notZen(PatternData ptData) {
    return ptData.title != PatternService.zenMode;
  }

  void handleButtonPress() {
    setState(() {
      // Indstil knappen som ikke trykbar
      canPressButton = false;

      // Start en timer, der aktiverer knappen efter 5 sekunder
      Timer(const Duration(seconds: 5), () {
        setState(() {
          canPressButton = true;
        });
      });

      // Implementer logik for knaptryk
      helpOut(selectedPatternData);
      compareForCorrect();
    });
  }

  MyHomePageState() {
    // Initialize
    patternSelect(patternService.getPattern("Solen"));
    helpOut(selectedPatternData);
    resetCompare();
  }

  List<List<bool>> resetCompare() {
    return correctness = List.generate(
        rowCount, (index) => List.generate(colCount, (index) => true));
  }

  void setPattern(PatternData patternData) {
    setState(() {
      patternSelect(patternData);
      // Opdater rowCount og colCount here, so they have the correct amounts
      rowCount = patternData.height;
      colCount = patternData.width;
      // Opdater gridColors og correctness med de nye rowCount og colCount
      initGridColors();
      correctness = resetCompare();

      helpOut(patternData);
    });
  }

  void initGridColors() {
    gridColors = List.generate(
      rowCount,
      (index) => List.generate(colCount, (index) => Colors.grey),
    );
  }

  void helpOut(PatternData patternData) {
    // No help out on zen mode
    if(!notZen(patternData)) {
      return;
    }
    int help = 4;
    // Sæt farverne for de første fire ikke-hvide firkanter
    outer:
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < colCount; col++) {
        if (gridColors[row][col] == Colors.grey &&
            patternData.patternColors[row][col] == Colors.white54) {
          gridColors[row][col] = patternData.patternColors[row][col];
        }
        if (patternData.patternColors[row][col] != Colors.white54 &&
            gridColors[row][col] != patternData.patternColors[row][col]) {
          gridColors[row][col] = patternData.patternColors[row][col];
          help--;
          if (help <= 0) {
            break outer;
          }
        }
      }
    }
  }

  void patternSelect(PatternData patternData) {
    if (patternData.title == 'Zen') {
      rowCount = colCount = 16;
      selectedPatternData = PatternData([[]], rowCount, colCount, 'Zen');
    } else {
      rowCount = patternData.height;
      colCount = patternData.width;
      selectedPatternData = patternData;
    }
    initGridColors();
  }

  void showPatternDialog() {
    var availablePatterns = patternService.getAvailablePatterns();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: SingleChildScrollView(
              child: Wrap(
                children: availablePatterns.map((pattern) {
                  return GestureDetector(
                    onTap: () {
                      resetCompare();
                      setPattern(patternService.getPattern(pattern));
                      compareActive = activateStar = false;
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Text(pattern),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: buildPreview(
                              patternService.getPattern(pattern), 0.1),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
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
        onPanEnd: (_) {
          compareForCorrect();
        },
        onTapUp: (_) {
          compareForCorrect();
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

            return activateStar && gridColors[row][col] == Colors.white54
                ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, build) {
                      return CustomPaint(
                          painter: StarPainter(_animation.value),
                          size: const Size(40, 40));
                    })
                : Container(
                    margin: const EdgeInsets.all(2),
                    color: gridColors[row][col],
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: gridColors[row][col],
                        border: notZen(selectedPatternData) &&
                                !correctness[row][col]
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

  Widget buildPreview(PatternData selectedPatternData, double box) {
    int width = selectedPatternData.width > 0 ? selectedPatternData.width : 1;
    int height =
        selectedPatternData.height > 0 ? selectedPatternData.height : 1;

    // Juster faktorerne for at ændre størrelsen af miniaturebilledet
    final double boxSize = min(40, MediaQuery.of(context).size.width * box);

    return GestureDetector(
            child: SizedBox(
              height: height.toDouble() * boxSize,
              width: width.toDouble() * boxSize,
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
            ),
          );
  }

  Widget buildZen() {
    return Wrap(
            children: [
              SizedBox(
                width: 200,
                child: Slider(
                  value: max(minCount, rowCount.toDouble()),
                  min: minCount,
                  max: maxCount,
                  onChanged: (value) {},
                  onChangeEnd: (value) {
                    rowCount = value.round();
                    colCount = value.round();
                    setState(() {
                      initGridColors();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
  }

  // Calculate colCount based on rowCount to maintain 16:9 ratio
  int calculateColCount() {
    return min(
        maxCount.toInt(), max(minCount.toInt(),((rowCount ).round())));
        //maxCount.toInt(), max(minCount.toInt(), ((rowCount * 9) / 16).round()));
  }

  // Calculate rowCount based on colCount to maintain 16:9 ratio
  int calculateRowCount() {
    return min(
        maxCount.toInt(), max(minCount.toInt(), ((colCount.round()))));
        //maxCount.toInt(), max(minCount.toInt(), ((colCount * 16) / 9).round()));
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

  void compareForCorrect() {
    if (notZen(selectedPatternData)) {
      for (int row = 0; row < rowCount; row++) {
        for (int col = 0; col < colCount; col++) {
          if (row < selectedPatternData.height &&
              col < selectedPatternData.width) {
            if (!(gridColors[row][col] ==
                selectedPatternData.patternColors[row][col])) {
              setState(() {
                activateStar = false;
              });
              return;
            }
          }
        }
      }
      setState(() {
        activateStar = true;
      });
    }
  }

  void saveShare(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShareDialog(outputText: encodePattern(selectedPatternData)); // Erstat med din outputtekst
      },
    );
  }

}

class SimpleColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const SimpleColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6.0, // Juster afstanden mellem farvecirklerne efter behov
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
    final double iconSize = MediaQuery.of(context).size.width * 0.05;
    return GestureDetector(
      onTap: () {
        onColorChanged(color);
      },
      child: Container(
        width: iconSize,
        height: iconSize,
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
