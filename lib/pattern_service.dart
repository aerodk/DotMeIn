import 'package:flutter/material.dart';

class PatternService {
  static const String zenMode = 'Zen';

  var nameList = List.of([zenMode
    , 'Hjerte'
    , 'Alberts kat'
    , 'Solen'
    , 'Dannebrog'
    , 'Blå og gul']);
  var patternList = List.of(['''.''',
      '''
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
      ..B..B........ 
      ..YBBY........              
      .BBBBBB.......
      ..BKKB......B.
      ...RR........B
      ...BB........B
      ...BBBBBBBBBBB
      ....BBBBBBBBB. 
      .....BBBBBBB.. 
      ......BBBBB... 
      GGGGGGGBBGBGGG
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
    '''      ,
    '''
    ......RR......
    ......RR......
    ......RR......
    .RRRRRRRRRRRR.
    .RRRRRRRRRRRR.
    ......RR......
    ......RR......
    ......RR......
    ''',
    '''
    ..............
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
    .YYYYYYYYYYYY.
    .BBBBBBBBBBBB.
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

      return PatternData(patternColors, width, height, pattern);
    } else {
      // Returner et tomt mønster, hvis mønsteret ikke findes
      return PatternData([], 0, 0, '');
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
      case 'G':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'K':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}

class PatternData {
  final String title;
  final List<List<Color>> patternColors;
  final int width;
  final int height;

  PatternData(this.patternColors, this.width, this.height, this.title);
}
