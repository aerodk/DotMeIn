// Funktion til at kode mønsterdata til en Base64-kodet streng
import 'dart:convert';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:dot_me_in/pattern_service.dart';

// Funktion til at kode mønsterdata til en Base64-streng
String encodePattern(PatternData patternData) {
  // Konverter mønsterdataene til JSON
  Map<String, dynamic> patternMap = {
    'title': patternData.title,
    'width': patternData.width,
    'height': patternData.height,
    'patternColors': patternData.patternColors.map((row) {
      return row.map((color) => color.value).toList();
    }).toList(),
  };
  String jsonPattern = jsonEncode(patternMap);

  // Konverter JSON-strengen til bytes
  // Base64-kod bytes
  var encode = GZipEncoder().encode(utf8.encode(jsonPattern));
  String base64Pattern = base64Encode(encode!);
  return base64Pattern;
}


// Funktion til at afkode mønsterdata fra en Base64-kodet streng
PatternData decodePattern(String base64Pattern) {
  // Base64-dekod strengen til bytes
  // Konverter bytes til JSON-streng
  var base64decode = base64Decode(base64Pattern);

  List<int> decompressedBytes = GZipDecoder().decodeBytes(base64decode);

  String jsonPattern = utf8.decode(decompressedBytes);
  // Afkod JSON-strengen til et map af mønsterdata
  Map<String, dynamic> decodedPatternMap = jsonDecode(jsonPattern);
  // Udtræk mønsterdata fra det afkodede map
  String title = decodedPatternMap['title'];
  int width = decodedPatternMap['width'];
  int height = decodedPatternMap['height'];
  List<List<dynamic>> patternColors = List<List<dynamic>>.from(decodedPatternMap['patternColors']);

  // // Konverter farverne til heltal
  List<List<int>> patternColorInts = patternColors.map((row) {
    return List<int>.from(row);
  }).toList();

  // Konverter heltalsfarverne til farver
  List<List<Color>> colors = patternColorInts.map((row) {
    return row.map((value) {
      return Color(value);
    }).toList();
  }).toList();

  // Returner mønsterdataene som et PatternData-objekt
  return PatternData(colors, width, height, title);
}
