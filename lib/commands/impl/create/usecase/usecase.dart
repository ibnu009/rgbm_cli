import 'dart:io';

import 'package:recase/recase.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../interface/command.dart';

class CreateUsecaseCommand extends Command {
  @override
  String get commandName => 'use_case';

  @override
  List<String> get alias => ['-u', 'uc'];

  @override
  int get maxParameters => 1;

  @override
  String get codeSample => 'rgb create -u address';

  @override
  String? get hint => LocaleKeys.hint_create_controller.tr; // reuse generic hint

  @override
  Future<void> execute() async {
    var usecaseName = name.trim();
    if (usecaseName.isEmpty) {
      throw Exception('Usecase name is required. Example: $codeSample');
    }

    final snake = usecaseName.snakeCase;
    final pascal = usecaseName.pascalCase;

    final baseDir = 'lib/domain/use_case/$snake';
    Directory(baseDir).createSync(recursive: true);

    final interfacePath = '$baseDir/${snake}_interface.dart';
    final usecasePath = '$baseDir/${snake}_use_case.dart';

    // Interface content
    final interfaceContent = '''import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ${pascal}Interface {
 // TODO: implement interface for ${pascal}

//   Future<Either<DioException, dynamic>> fetch${pascal}s({
//     required CancelToken cancelToken,
//     required int page,
//     required int size,
//   });
}
''';

    // Usecase content
    final usecaseContent = '''import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '${snake}_interface.dart';

class ${pascal}UseCase implements ${pascal}Interface {
  // TODO: import services for ${pascal}
  
  // TODO: implement business logic for ${pascal}UseCase
 
}
''';

    writeFile(interfacePath, interfaceContent, overwrite: true);
    writeFile(usecasePath, usecaseContent, overwrite: true);
  }
}
