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
}
