import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:boostrap/config/cons_val.dart';

class PluginsAnalysis {
  ///
  /// 解析插件信息
  ///
  List<String?> getPluginsPath(String projectPath) {
    String plugins = path.join(projectPath, ConsVal.pluginsTag);
    final file = File(plugins);
    if (!file.existsSync()) {
      return [];
    }
    List<String?> result = file
        .readAsLinesSync()
        .where((element) => element.contains("="))
        .map((e) => e.split("=").last)
        .toList();
    return result;
  }
}
