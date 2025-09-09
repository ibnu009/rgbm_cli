import '../../common/utils/pubspec/pubspec_utils.dart';
import '../interface/sample_interface.dart';

/// [Sample] file from Module_View file creation.
class GetViewSample extends Sample {
  final String _viewModelDir;
  final String _viewName;
  final String _viewModel;

  GetViewSample(super.path, this._viewName, this._viewModel,
      this._viewModelDir,
      {super.overwrite});

  String get import => _viewModelDir.isNotEmpty
      ? '''import 'package:${PubspecUtils.projectName}/$_viewModelDir';'''
      : '';

  String get _viewModelName =>
      _viewModel.isNotEmpty ? 'BaseView<$_viewModel>' : 'BaseView';

  String get _flutterView => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:${PubspecUtils.projectName}/presentation/base/base_view.dart';
$import

class $_viewName extends $_viewModelName {
  const $_viewName({super.key});

  @override
  Widget body(BuildContext context) {
    return const Center(
      child: Text('$_viewName is ready'),
    );
  }

  @override
  appBar(BuildContext context) {
    return AppBar(
      title: Text("$_viewName"),
    );
  }
}
  ''';
  
  @override
  String get content =>  _flutterView;
}
