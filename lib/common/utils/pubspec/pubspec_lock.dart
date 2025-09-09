import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../../functions/version/check_dev_version.dart';
import '../logger/log_utils.dart';

class PubspecLock {
  static Future<String?> getVersionCli({bool disableLog = false}) async {
    try {
      // Primary: resolve our own package pubspec.yaml via package: URI
      final pkgUri = await Isolate.resolvePackageUri(
          Uri.parse('package:rgb_cli/pubspec.yaml'));
      if (pkgUri != null) {
        final pubspecFile = File(pkgUri.toFilePath());
        if (await pubspecFile.exists()) {
          final yaml = loadYaml(await pubspecFile.readAsString());
          final version = yaml['version']?.toString();
          if (version != null && version.isNotEmpty) {
            return version;
          }
        }
      }

      // Fallback A: try to read pubspec.yaml relative to the script location
      var scriptFile = Platform.script.toFilePath();
      var scriptDir = dirname(scriptFile);
      var pathToPubspec = join(scriptDir, '../pubspec.yaml');
      final pubspecNearScript = File(pathToPubspec);
      if (await pubspecNearScript.exists()) {
        final yaml = loadYaml(await pubspecNearScript.readAsString());
        final version = yaml['version']?.toString();
        if (version != null && version.isNotEmpty) {
          return version;
        }
      }

      // Fallback B: try to read pubspec.lock relative to the script location
      var pathToPubLock = join(scriptDir, '../pubspec.lock');
      final file = File(pathToPubLock);
      if (await file.exists()) {
        var text = loadYaml(await file.readAsString());
        if (text['packages'] != null && text['packages']['rgb_cli'] != null) {
          var version = text['packages']['rgb_cli']['version'].toString();
          return version;
        }
      }

      if (isDevVersion()) {
        if (!disableLog) {
          LogService.info('Development version');
        }
      }
      return null;
    } on Exception catch (e, st) {
      if (!disableLog) {
        // Detailed diagnostics to help troubleshoot globally activated setups
        LogService.error('Version lookup failed: $e');
        // ignore: avoid_print
        print(st);
        LogService.error(
            Translation(LocaleKeys.error_cli_version_not_found).tr);
      }
      return null;
    }
  }
}
