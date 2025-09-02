import '../../../common/utils/pubspec/pubspec_utils.dart';

/// Install get kalau belum ada GetX di pubspec.yaml
Future<void> installGet([bool runPubGet = false]) async {
  PubspecUtils.removeDependencies('get', logger: false);
  await PubspecUtils.addDependencies('get', runPubGet: runPubGet);
}
