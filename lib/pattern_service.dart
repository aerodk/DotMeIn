import 'package:flutter/material.dart';

class PatternService {
  var nameList = List.of(['Hjerte', 'Solen']);
  var patternList = List.of(['''
      .............. 
      ....RR..RR....
      ...RRRRRRRR...
      ..RRRRRRRRRR..
      ..RRRRRRRRRR..
      ...RRRRRRRR...
      ....RRRRRR....
      .....RRRRR.... 
      ......RRR..... 
      .......R...... 
      ..............
      '''
      ,
    '''
    ......OO......
    ....OOOOOO....
    ...OOOOOOOO...
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ....OOOOOO....
    ......OO......
    ..............
    '''
  ]);

  List<String> getAvailablePatterns() {
    return nameList;
  }

  PatternData getPattern(String pattern) {
    var selectedPatternIndex = nameList.indexOf(pattern);
    if (selectedPatternIndex != -1) {
      var rows = patternList[selectedPatternIndex].split('\n').map((String row) => row.trim()).toList();
      var height = rows.length-1;
      var width = rows.isNotEmpty ? rows[0].length : 0;

      // Konverter mønsteret til en liste af farver
      List<List<Color>> patternColors = List.generate(
        height,
            (rowIndex) => List.generate(
          width,
              (colIndex) {
            var indicator = rows[rowIndex][colIndex];
            return indicator == '.' ? Colors.white54 : getColor(indicator);
          },
        ),
      );

      return PatternData(patternColors, width, height);
    } else {
      // Returner et tomt mønster, hvis mønsteret ikke findes
      return PatternData([], 0, 0);
    }
  }

  Color getColor(String indicator) {
    switch (indicator) {
      case 'R':
        return Colors.red;
      case 'Y':
        return Colors.yellow;
      case 'O':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class PatternData {
  final List<List<Color>> patternColors;
  final int width;
  final int height;

  PatternData(this.patternColors, this.width, this.height);
}
