library translation_key_generator;

import 'dart:convert';
import 'dart:io';

class TranslationKeysGenerator {
  Future<void> generateKeys({
    required String inputDir,
    required String outputFile,
  }) async {
    final keys = <String>{};

    // Read all JSON files in the input directory
    final dir = Directory(inputDir);
    if (!dir.existsSync()) {
      throw Exception('Directory $inputDir does not exist.');
    }

    final jsonFiles =
        dir.listSync().where((file) => file.path.endsWith('.json'));

    for (var file in jsonFiles) {
      final content = await File(file.path).readAsString();
      final jsonData = json.decode(content) as Map<String, dynamic>;
      keys.addAll(_extractKeys(jsonData));
    }

    // Generate Dart class
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('class TranslationKeys {');
    for (var key in keys) {
      final formattedKey = key.replaceAll('.', '_').replaceAll('-', '_');
      buffer.writeln("  static const String $formattedKey = '$key';");
    }
    buffer.writeln('}');

    // Write to file
    await File(outputFile).writeAsString(buffer.toString());
  }

  Set<String> _extractKeys(Map<String, dynamic> jsonData,
      [String prefix = '']) {
    final keys = <String>{};
    for (var key in jsonData.keys) {
      final value = jsonData[key];
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        keys.addAll(_extractKeys(value, fullKey));
      } else {
        keys.add(fullKey);
      }
    }
    return keys;
  }
}
