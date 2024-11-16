import 'package:build/build.dart';
import 'package:translation_key_generator/translation_keys_generator.dart';

void main(List<String> args) async {
  if (args.length < 2) {
    log.warning('Usage: dart run generate_keys.dart <input_dir> <output_file>');
    return;
  }

  final inputDir = args[0];
  final outputFile = args[1];

  try {
    final generator = TranslationKeysGenerator();
    await generator.generateKeys(inputDir: inputDir, outputFile: outputFile);
    log.info('Translation keys generated at $outputFile');
  } catch (e) {
    log.severe('Error: $e');
  }
}
