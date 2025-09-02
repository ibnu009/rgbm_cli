import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../samples/impl/analysis_options.dart';
import '../../../interface/command.dart';
import '../../init/flutter/init.dart';

class CreateProjectCommand extends Command {
  @override
  String get commandName => 'project';
  @override
  Future<void> execute() async {
    String? nameProject = name;
    if (name == '.') {
      nameProject = ask(LocaleKeys.ask_name_to_project.tr);
    }

    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameProject.snakeCase);
    await Directory(path).create(recursive: true);

    Directory.current = path;
      var org = ask(
        '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
        '${LocaleKeys.example.tr} com.yourcompany \x1B[0m',
      );

      final iosLangMenu =
          Menu(['Swift', 'Objective-C'], title: LocaleKeys.ask_ios_lang.tr);
      final iosResult = iosLangMenu.choose();

      var iosLang = iosResult.index == 0 ? 'swift' : 'objc';

      final androidLangMenu =
          Menu(['Kotlin', 'Java'], title: LocaleKeys.ask_android_lang.tr);
      final androidResult = androidLangMenu.choose();

      var androidLang = androidResult.index == 0 ? 'kotlin' : 'java';

      final linterMenu = Menu([
        'Yes',
        'No',
      ], title: LocaleKeys.ask_use_linter.tr);
      final linterResult = linterMenu.choose();

      await ShellUtils.flutterCreate(path, org, iosLang, androidLang);

      File('test/widget_test.dart').writeAsStringSync('');

      switch (linterResult.index) {
        case 0:
          await PubspecUtils.addDependencies('flutter_lints',
              isDev: true, runPubGet: true);
          AnalysisOptionsSample(
              include: 'include: package:flutter_lints/flutter.yaml')
              .create();
          break;

        default:
          AnalysisOptionsSample().create();
      }
      await InitCommand().execute();
  }

  @override
  String? get hint => LocaleKeys.hint_create_project.tr;

  @override
  bool validate() {
    return true;
  }

  @override
  String get codeSample => 'rgb create project';

  @override
  int get maxParameters => 0;
}
