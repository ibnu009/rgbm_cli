import 'dart:io';

import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/exports_files/add_export.dart';
import '../../../../functions/routes/arc_add_route.dart';
import '../../../../samples/impl/get_binding.dart';
import '../../../../samples/impl/get_view_model.dart';
import '../../../../samples/impl/get_view.dart';
import '../../../interface/command.dart';

class CreateScreenCommand extends Command {
  @override
  String get commandName => 'screen';

  @override
  Future<void> execute() async {
    var isProject = false;
    if (RgbCli.arguments[0] == 'create') {
      isProject = RgbCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }

    var newFileModel =
        Structure.model(name, 'screen', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu([
        LocaleKeys.options_yes.tr,
        LocaleKeys.options_no.tr,
      ], title: LocaleKeys.ask_existing_page.trArgs([name]).toString());
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name, overwrite: true);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name);
    }
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_create_screen).tr;

  @override
  bool validate() {
    return true;
  }

  void _writeFiles(String path, String name, {bool overwrite = false}) {

    var controller = handleFileCreate(name, 'view_model', path, true,
        ViewModelSample('', name), 'view_model', '.');

    var controllerImport = Structure.pathToDirImport(controller.path);

    var view = handleFileCreate(
        name,
        'screen',
        path,
        false,
        GetViewSample(
          '',
          '${name.pascalCase}Screen',
          '${name.pascalCase}ViewModel',
          controllerImport,
        ),
        '',
        '.');
    var binding = handleFileCreate(
        name,
        'view_model.binding',
        '',
        true,
        BindingSample(
          '',
          name,
          '${name.pascalCase}Binding',
          controllerImport,
        ),
        'view_model',
        '.');

    var exportView = 'package:${PubspecUtils.projectName}/'
        '${Structure.pathToDirImport(view.path)}';
    addExport('lib/presentation/screens.dart', "export '$exportView';");

    addExport(
        'lib/infrastructure/navigation/bindings/controllers/view_model_bindings.dart',
        "export 'package:${PubspecUtils.projectName}/${Structure.pathToDirImport(binding.path)}'; ");

    arcAddRoute(name);
  }

  @override
  String get codeSample => 'rgb create screen:name';

  @override
  int get maxParameters => 0;
}
