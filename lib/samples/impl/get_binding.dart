import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../interface/sample_interface.dart';

/// [Sample] file from Module_Binding file creation.
class BindingSample extends Sample {
  final String _fileName;
  final String _controllerDir;
  final String _bindingName;

  BindingSample(super.path, this._fileName, this._bindingName,
      this._controllerDir,
      {super.overwrite});

  String get _import => "import 'package:get/get.dart';";

  @override
  String get content => '''$_import
import 'package:${PubspecUtils.projectName}/$_controllerDir';

class $_bindingName extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${_fileName.pascalCase}ViewModel>(
      () => ${_fileName.pascalCase}ViewModel(),
    );
  }
}
''';
}
