
// Koden til PatternData og encodePattern/dekodePattern skal indsættes her

import 'package:dot_me_in/encodeUtils.dart';
import 'package:dot_me_in/pattern_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test encodePattern and decodePattern functions', () {
    // Opret et eksempel på mønsterdata,
    // the reason for Color(Colors.x.value) is to not use materialcolors in the test
    // to avoid issues on the compare, since color is only used in decode
    List<List<Color>> originalPatternColors = [
      [Color(Colors.red.value), Color(Colors.blue.value)],
      [Color(Colors.green.value), Color(Colors.yellow.value)]
    ];
    PatternData originalPatternData = PatternData(originalPatternColors, 2, 2, 'Example Pattern');

    // Kode mønsterdataene til en Base64-kodet streng
    String encodedPattern = encodePattern(originalPatternData);

    // Afkode mønsterdataene fra den Base64-kodede streng
    PatternData decodedPatternData = decodePattern(encodedPattern);

    // Sammenlign dekodet mønsterdata med det oprindelige mønster
    expect(decodedPatternData.patternColors, originalPatternData.patternColors);
    expect(decodedPatternData.width, originalPatternData.width);
    expect(decodedPatternData.height, originalPatternData.height);
    expect(decodedPatternData.title, originalPatternData.title);
  });

  test('Test encodePattern and decodePattern functions on patternservice', () {
    PatternData originalPatternData = PatternService().getPattern('Solen');

    // Kode mønsterdataene til en Base64-kodet streng
    String encodedPattern = encodePattern(originalPatternData);

    // Afkode mønsterdataene fra den Base64-kodede streng
    PatternData decodedPatternData = decodePattern(encodedPattern);

    // Sammenlign dekodet mønsterdata med det oprindelige mønster
    expect(decodedPatternData.patternColors, originalPatternData.patternColors);
    expect(decodedPatternData.width, originalPatternData.width);
    expect(decodedPatternData.height, originalPatternData.height);
    expect(decodedPatternData.title, originalPatternData.title);
  });
}
