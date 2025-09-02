import '../../interface/sample_interface.dart';

/// Sample that generates a minimal lib/main.dart for GetX pattern projects.
class GetXMainSample extends Sample {
  GetXMainSample({super.overwrite}) : super('lib/main.dart');

  @override
  String get content => _main;

  static const String _main = '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RGB App',
      debugShowCheckedModeBanner: false,
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('GetX pattern app is ready')),
    );
  }
}
''';
}
