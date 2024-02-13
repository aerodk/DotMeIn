import 'package:dot_me_in/pattern_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test getPattern method with "Hjerte"', () {
    PatternService patternService = PatternService();
    PatternData patternData = patternService.getPattern("Hjerte");

    // Forventede værdier baseret på det statiske mønster for "Hjerte"
    expect(patternData.width, 14);
    expect(patternData.height, 11);

    // Tilføj flere forventede værdier efter behov
  });

  test('Test getPattern method with "Zen"', () {
    PatternService patternService = PatternService();
    PatternData patternData = patternService.getPattern("Zen");

    // Forventede værdier baseret på det statiske mønster for "Zen"
    expect(patternData.width, 12);
    expect(patternData.height, 9);

    // Tilføj flere forventede værdier efter behov
  });
}
