import 'package:process_run/shell_run.dart';

import '../../common/utils/logger/log_utils.dart';
import '../interface/command.dart';

class BuildCommand extends Command {
  @override
  String get commandName => 'build';

  @override
  List<String> get acceptedFlags => [
        '-a',
        '-android',
        '-i',
        '-ios',
        '-s',
        '-staging',
        '-p',
        '-production',
        '-aab',
      ];

  @override
  String? get hint =>
      'Build app using build-app.sh script (See Build Command for more detail)';

  @override
  Future<void> execute() async {
    final isAndroid = flags.contains('-a') || flags.contains('-android');
    final isIOS = flags.contains('-i') || flags.contains('-ios');
    final isStaging = flags.contains('-s') || flags.contains('-staging');
    final isProduction = flags.contains('-p') || flags.contains('-production');
    final isAab = flags.contains('-aab');

    if (!isAndroid && !isIOS) {
      LogService.error('Please specify platform: -a/--android or -i/--ios');
      return;
    }

    // If AAB requested, force Android + production
    final platformAndroid = isAndroid || isAab;
    final envStaging = isStaging && !isAab;
    final envProduction = isProduction || isAab;

    if (platformAndroid) {
      if (isAab) {
        // Build Android App Bundle (production)
        final cmd =
            'bash build-app.sh -b=appbundle -e=production/.env --add-args=--flavor=production --add-args=--release --add-args=--target=lib/main_production.dart';
        LogService.info('Running: $cmd');
        await run(cmd, verbose: true);
        LogService.success('Android AAB (production) build finished.');
        return;
      }

      if (!envStaging && !envProduction) {
        LogService.error('Please specify environment for Android: -s/--staging or -p/--production');
        return;
      }

      final flavor = envStaging ? 'staging' : 'production';
      final target = envStaging ? 'lib/main_staging.dart' : 'lib/main_production.dart';
      final envFile = envStaging ? 'staging/.env' : 'production/.env';
      final cmd =
          'bash build-app.sh -b=apk -e=$envFile --add-args=--flavor=$flavor --add-args=--release --add-args=--target=$target';
      LogService.info('Running: $cmd');
      await run(cmd, verbose: true);
      LogService.success('Android APK ($flavor) build finished.');
      return;
    }

    if (isIOS) {
      if (!envStaging && !envProduction) {
        LogService.error('Please specify environment for iOS: -s/--staging or -p/--production');
        return;
      }
      final flavor = envStaging ? 'staging' : 'production';
      final target = envStaging ? 'lib/main_staging.dart' : 'lib/main_production.dart';
      final envFile = envStaging ? 'staging/.env' : 'production/.env';
      final cmd =
          'bash build-app.sh -b=ipa -e=$envFile --add-args=--flavor=$flavor --add-args=--release --add-args=--target=$target';
      LogService.info('Running: $cmd');
      await run(cmd, verbose: true);
      LogService.success('iOS IPA ($flavor) build finished.');
      return;
    }
  }

  @override
  int get maxParameters => 0;

  @override
  String get codeSample => 'rgb build -a -s';
}
