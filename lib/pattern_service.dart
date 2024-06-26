import 'package:flutter/material.dart';

class PatternService {
  static const String zenMode =
      'Zen'; // Tilføj static for at gøre det til en klassekonstant

  // Brug statiske konstanter for mønsternavne
  static const String heartPattern = 'Hjerte';
  static const String albertsCatPattern = 'Alberts kat';
  static const String sunPattern = 'Solen';
  static const String danishFlagPattern = 'Dannebrog';
  static const String blueAndYellowPattern = 'Blå og gul';

  var nameList = List.of([
    zenMode,
    heartPattern,
    albertsCatPattern,
    sunPattern,
    danishFlagPattern,
    blueAndYellowPattern
  ]);

  static var patternList = List.of([
    '''
  ............
  .KKKKKKKKKK..
  ......KKKK...
  .....KKKK....
  ....KKKK.....
  ...KKKK......
  ..KKKK.......
  .KKKKKKKKKK..
  .............
  ''',
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
      ''',
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
      ''',
    '''
    ......OO......
    ....OOOOOO....
    ...OOOOOOOO...
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ....OOOOOO....
    ......OO......
    ..............
    ''',
    '''
    ....RR........
    ....RR........
    ....RR........
    .RRRRRRRRRRRR.
    .RRRRRRRRRRRR.
    ....RR........
    ....RR........
    ....RR........
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
      List<String> rows = patternList[selectedPatternIndex]
          .split('\n')
          .where((row) => row.trim().isNotEmpty)
          .map((row) => row.trim())
          .toList();
      var height = rows.length;
      var width = rows.isNotEmpty ? rows[0].length : 0;

      // Konverter mønsteret til en liste af farver
      List<List<Color>> patternColors = List.generate(
        height,
        (rowIndex) => List.generate(
          width,
          (colIndex) {
            var indicator = rows[rowIndex][colIndex];
            return indicator == '.' ? Color(Colors.white54.value) : getColor(indicator);
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
        return Color(Colors.red.value);
      case 'Y':
        return Color(Colors.yellow.value);
      case 'O':
        return Color(Colors.orange.value);
      case 'G':
        return Color(Colors.green.value);
      case 'B':
        return Color(Colors.blue.value);
      case 'K':
        return Color(Colors.black.value);
      default:
        return Color(Colors.grey.value);
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
