import 'package:rgb_cli/functions/version/print_get_cli.dart';

import '../../../common/utils/pubspec/pubspec_lock.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../interface/command.dart';

// ignore_for_file: avoid_print

class VersionCommand extends Command {
  @override
  String get commandName => '--version';

  @override
  Future<void> execute() async {
    var version = await PubspecLock.getVersionCli();
    if (version == null) return;
    printRGBCli();
    print('Version: $version');
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_version).tr;

  @override
  List<String> get alias => ['-v', '-version'];

  @override
  bool validate() {
    super.validate();

    return true;
  }

  @override
  String get codeSample => 'rgb --version';

  @override
  int get maxParameters => 0;
}
