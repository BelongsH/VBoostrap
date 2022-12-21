import 'package:boostrap/config/cons_val.dart';
import 'package:boostrap/plugins/dart_core_analysis.dart';
import 'package:boostrap/plugins/dart_file_manager.dart';
import 'package:boostrap/plugins/plugins_analysis.dart';
import 'package:path/path.dart' as path;
import 'package:boostrap/vo/plugin_vo.dart';

class ModuleCoreExecutor {
  final PluginVo extra;

  final PluginsAnalysis pluginsAnalysis = PluginsAnalysis();

  final DartFileManager dartFileManager = DartFileManager();

  final DartCoreAnalysis dartCoreAnalysis = DartCoreAnalysis();

  ModuleCoreExecutor({required this.extra});

  void doExecute() async {
    List<String> hitFiles = [];
    final paths = _filterModulePath();
    for (String? element in paths) {
      String uri = path.isRelative(element!)
          ? path.join(extra.scannerProjectPath, ConsVal.dartToolTag, element)
          : element;

      final dd=dartFileManager.totalFiles(path.join(uri, ConsVal.coreLib)).where((e) =>
      e.contains(extra.hitPackageTag) && e.endsWith(ConsVal.dartFile)).toList();

      hitFiles.addAll(
        dartFileManager.totalFiles(path.join(uri, ConsVal.coreLib)).where((e) =>
            e.contains(extra.hitPackageTag) && e.endsWith(ConsVal.dartFile)),
      );
    }
    dartCoreAnalysis.classVisitor(hitFiles);
  }

  ///
  /// 获取插件信息
  ///
  List<String?> _filterModulePath() {
    final plugins = pluginsAnalysis.getPluginsPath(extra.scannerProjectPath);
    if (plugins.isEmpty) {
      print(
          '---------------- 没有发现该路径${extra.scannerProjectPath} 存在有依赖项目   ----------------');
      return [];
    } else {
      return plugins
          .where((e) => e != null)
          .where((e) => e!.contains(extra.hitModuleTag))
          .toList();
    }
  }
}
