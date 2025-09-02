import 'package:recase/recase.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_ViewModel file creation.
class ViewModelSample extends Sample {
  final String _fileName;
  final String _usecaseImportDir;
  ViewModelSample(
    super.path,
    this._fileName, {
    String usecaseImportDir = '',
    super.overwrite,
  }) : _usecaseImportDir = usecaseImportDir;

  @override
  String get content => flutterViewModel;

  String get _imports => _usecaseImportDir.isNotEmpty
      ? "import 'package:${PubspecUtils.projectName}/presentation/base/base_view_model.dart';\nimport 'package:${PubspecUtils.projectName}/$_usecaseImportDir';"
      : "import 'package:${PubspecUtils.projectName}/presentation/base/base_view_model.dart';";

  String get flutterViewModel => '''$_imports

class ${_fileName.pascalCase}ViewModel extends BaseViewModel {
  final ${_fileName.pascalCase}UseCase _useCase = ${_fileName.pascalCase}UseCase();
}
''';
}
