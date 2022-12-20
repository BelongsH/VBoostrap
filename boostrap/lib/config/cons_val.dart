class ConsVal {
  ///需要解析的包路径
  static String coreLib = 'lib';

  /// 解析
  static String dartFile = '.dart';

  /// 模块的存放目录
  static String targetModuleTag = "packages";

  /// 目标目录
  static String targetPackageTag = 'init';

  /// 目标类文件
  static String targetSuperClassName = "ModuleLifecycle";

  /// 插件相关
  static String pluginsTag=".flutter-plugins";

  /// 输出文件信息
  static String outputFilePath = "lib/generated/main_module_lifecycle.dart";
}

class ArgsVal {
  static String project = "project";
  static String outputFile = "outputFile";
  static String packages = "packages";
  static String pack = "pack";
}
