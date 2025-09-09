import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/routes/get_add_route.dart';
import '../../../../samples/impl/get_binding.dart';
import '../../../../samples/impl/get_view_model.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

/// The command create a Binding and Controller page and view
class CreatePageCommand extends Command {
  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['module', '-p'];

  @override
  Future<void> execute() async {
    var isProject = false;
    if (RgbCli.arguments[0] == 'create' || RgbCli.arguments[0] == '-c') {
      isProject = RgbCli.arguments[1].split(':').first == 'project';
    }

    var fullName = name;
    if (fullName.isEmpty || isProject) {
      fullName = 'home';
    }

    // Extract module name from `-m` flag
    var moduleName = 'general'; // Default module
    for (var i = 0; i < RgbCli.arguments.length; i++) {
      if (RgbCli.arguments[i] == '-m' && i + 1 < RgbCli.arguments.length) {
        moduleName = RgbCli.arguments[i + 1]; // Assign module name
        break;
      }
    }

    checkForAlreadyExists(moduleName, fullName);
  }

  @override
  String? get hint => LocaleKeys.hint_create_page.tr;

  void checkForAlreadyExists(String moduleName, String? name) {
    var newFileModel = Structure.model(
      name,
      'page',
      true,
      on: onCommand,
      folderName: moduleName,
    );

    // Use full page folder path: lib/presentation/<module>/<name>
    var path = Structure.replaceAsExpected(path: newFileModel.path!);

    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title: Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(moduleName, path, name!, overwrite: true);
      } else if (result.index == 2) {
        var newName = ask(LocaleKeys.ask_new_page_name.tr);
        checkForAlreadyExists(moduleName, newName.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true); // Fix: Ensure the subdirectory is created
      _writeFiles(moduleName, path, name!, overwrite: false);
    }
  }

  void _writeFiles(String moduleName, String path, String name, {bool overwrite = false}) {
    var extraFolder = PubspecUtils.extraFolder ?? true;
    // 1) Generate Domain Usecase in lib/domain/use_case/<name>/{<name>_interface.dart,<name>_use_case.dart}
    final usecaseDir = 'lib/domain/use_case/${name.snakeCase}';
    Directory(usecaseDir).createSync(recursive: true);
    final interfacePath = '$usecaseDir/${name.snakeCase}_interface.dart';
    final usecasePath = '$usecaseDir/${name.snakeCase}_use_case.dart';

    // <name>_interface.dart
    writeFile(
      interfacePath,
      '''import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ${name.pascalCase}Interface {
  // TODO: implement interface for ${name.pascalCase}

  // Example signature (uncomment and adjust):
  // Future<Either<DioException, dynamic>> fetch${name.pascalCase}s({
  //   required CancelToken cancelToken,
  //   required int page,
  //   required int size,
  // });
}
''',
      overwrite: overwrite,
    );

    // <name>_use_case.dart (imports <name>_interface.dart)
    writeFile(
      usecasePath,
      '''import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '${name.snakeCase}_interface.dart';

class ${name.pascalCase}UseCase implements ${name.pascalCase}Interface {
  // TODO: import services for ${name.pascalCase}

  // TODO: implement business logic for ${name.pascalCase}UseCase
}
''',
      overwrite: overwrite,
    );

    // 2) Generate ViewModel that uses the Usecase
    var controllerFile = handleFileCreate(
      name,
      'view_model',
      path,
      extraFolder,
      ViewModelSample(
        '',
        name,
        usecaseImportDir: Structure.pathToDirImport(usecasePath),
        overwrite: overwrite,
      ),
      'view_model',
    );
    var controllerDir = Structure.pathToDirImport(controllerFile.path);
    var viewFile = handleFileCreate(
      name,
      'view',
      path,
      extraFolder,
      GetViewSample(
        '',
        '${name.pascalCase}View',
        '${name.pascalCase}ViewModel',
        controllerDir,
        overwrite: overwrite,
      ),
      'views',
    );
    var bindingFile = handleFileCreate(
      name,
      'binding',
      path,
      extraFolder,
      BindingSample(
        '',
        name,
        '${name.pascalCase}Binding',
        controllerDir,
        overwrite: overwrite,
      ),
      'bindings',
    );

    addRoute(
      moduleName,
      name,
      Structure.pathToDirImport(bindingFile.path),
      Structure.pathToDirImport(viewFile.path),
    );
    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
  }

  @override
  String get codeSample => 'rgb create page:product';

  @override
  int get maxParameters => 1;

  /// Extracts module name from `name` (if structured as `module/page`)
  String getModuleName(String? name) {
    if (name == null || !name.contains('/')) return name ?? 'general';
    return name.split('/').first;
  }

  /// Returns the path for the given module
  String getModulePath(String moduleName) {
    return 'lib/modules/$moduleName';
  }
}
