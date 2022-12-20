import 'dart:io';

class DartFileManager {
  ///
  ///  获取所有文件信息
  ///
  List<String> totalFiles(String rootPath) {
    final rootDir = Directory(rootPath);
    if (!rootDir.existsSync()) {
      return [];
    } else {
      return rootDir.listSync(recursive: true).map((e) => e.path).toList();
    }
  }
}
