import 'dart:convert';
import 'dart:io';

import 'package:boostrap/vo/package_vo.dart';
import 'package:path/path.dart' as path;
import 'package:boostrap/config/cons_val.dart';

class PluginsAnalysis {
  ///
  /// 解析插件信息
  ///
  List<PackageVo> getPluginsPath(String projectPath) {
    String plugins = path.join(projectPath, ConsVal.packageJsonTag);
    final file = File(plugins);
    if (!file.existsSync()) {
      return [];
    }
    final maps = jsonDecode(file.readAsStringSync());
    if (maps != null &&
        maps[ConsVal.jsonPackages] != null &&
        maps[ConsVal.jsonPackages] is List) {
      final packages = maps[ConsVal.jsonPackages] as List;
      return packages
          .map((e) =>PackageVo.fromJson(Map.from(e)))
          .toList();
    }
    //(e[ConsVal.jsonRootUri] as String).replaceAll(ConsVal.jsonFile, "")
    return [];
  }
}
