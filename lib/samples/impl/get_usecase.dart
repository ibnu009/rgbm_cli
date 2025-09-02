import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for Usecase generation: interface + implementation
class UsecaseSample extends Sample {
  final String _fileName;
  UsecaseSample(super.path, this._fileName, {super.overwrite});

  @override
  String get content => _usecaseContent;

  String get _usecaseContent => '''
/// Interface for ${_fileName.pascalCase} use case
abstract class I${_fileName.pascalCase}Usecase {
  Future<void> execute();
}

/// Implementation for ${_fileName.pascalCase} use case
class ${_fileName.pascalCase}Usecase implements I${_fileName.pascalCase}Usecase {
  @override
  Future<void> execute() async {
    // TODO: implement business logic for ${_fileName.pascalCase}
  }
}
''';
}
