import 'dart:io';

import 'package:recase/recase.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';

import '../../common/utils/logger/log_utils.dart';

void addRoute(String moduleName, String name, String bindingDir, String viewDir) {
  var routesFolder = Directory('lib/routes/routes');
  if (!routesFolder.existsSync()) {
    routesFolder.createSync(recursive: true);
  }

  var moduleFileName = '${moduleName.snakeCase}_route.dart';
  var moduleFilePath = 'lib/routes/routes/$moduleFileName';
  var moduleFile = File(moduleFilePath);

  if (!moduleFile.existsSync()) {
    moduleFile.writeAsStringSync(_generateModuleRoute(moduleName, name, bindingDir, viewDir));
  } else {
    _updateModuleRoute(moduleFile, moduleName, name, bindingDir, viewDir);
  }

  _updateRoutesFile(moduleName);
  LogService.success("Route for $name in module $moduleName created successfully!");
}

String _generateModuleRoute(String moduleName, String name, String bindingDir, String viewDir) {
  var className = '${moduleName.pascalCase}Route';
  return '''
import 'package:get/get.dart';
import 'package:${PubspecUtils.projectName}/$bindingDir';
import 'package:${PubspecUtils.projectName}/$viewDir';

class $className {
  static const ${name.camelCase}Route = "/${name.snakeCase}";
  static final routes = [
    GetPage(
      name: ${name.camelCase}Route,
      page: () => ${name.pascalCase}View(),
      binding: ${name.pascalCase}Binding(),
    ),
  ];
}
''';
}

void _updateModuleRoute(File moduleFile, String moduleName, String name, String bindingDir, String viewDir) {
  var content = moduleFile.readAsStringSync();
  var importStatement = "import 'package:${PubspecUtils.projectName}/$bindingDir';\nimport 'package:${PubspecUtils.projectName}/$viewDir';";
  var className = '${moduleName.pascalCase}Route';
  var constLine = '  static const ${name.camelCase}Route = "/${name.snakeCase}";';
  
  var routeEntry = '''
    GetPage(
      name: ${name.camelCase}Route,
      page: () => ${name.pascalCase}View(),
      binding: ${name.pascalCase}Binding(),
    ),
''';

  if (!content.contains(importStatement)) {
    content = "$importStatement\n$content";
  }

  // Ensure the static const route is declared inside the class
  if (!content.contains(constLine)) {
    content = content.replaceFirst(
      'class $className {',
      'class $className {\n$constLine',
    );
  }

  if (!content.contains(routeEntry)) {
    content = content.replaceFirst(
      "static final routes = [",
      "static final routes = [\n  $routeEntry",
    );
  }

  moduleFile.writeAsStringSync(content);
}

void _updateRoutesFile(String moduleName) {
  var routesFile = File('lib/routes/routes.dart');

  if (!routesFile.existsSync()) {
    routesFile.writeAsStringSync('''
import 'package:get/get.dart';

final routes = [
];''');
  }

  var content = routesFile.readAsStringSync();
  var importStatement = "import 'routes/${moduleName.snakeCase}_route.dart';";
  var routeEntry = "...${moduleName.pascalCase}Route.routes,";

  if (!content.contains(importStatement)) {
    content = "$importStatement\n$content";
  }

  if (!content.contains(routeEntry)) {
    content = content.replaceFirst("final routes = [", "final routes = [\n  $routeEntry");
  }

  routesFile.writeAsStringSync(content);
}

