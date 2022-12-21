import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:boostrap/config/cons_val.dart';

class PluginsAnalysis {
  ///
  /// 解析插件信息
  ///
  List<String?> getPluginsPath(String projectPath) {
    String plugins = path.join(projectPath, ConsVal.dartToolTag);
    final file = File(plugins);
    if (!file.existsSync()) {
      return [];
    }
    final maps = jsonDecode(file.readAsStringSync());
    if (maps != null &&
        maps[ConsVal.packages] != null &&
        maps[ConsVal.packages] is List) {
      final packages = maps[ConsVal.packages] as List;
      return packages
          .map((e) =>
              (e[ConsVal.rootUri] as String).replaceAll(ConsVal.file, ""))
          .toList();
    }
    List<String?> result = file
        .readAsLinesSync()
        .where((element) => element.contains("="))
        .map((e) => e.split("=").last)
        .toList();
    return result;
  }
}
