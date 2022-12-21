class ConsVal {
  ///需要解析的包路径
  static String coreLib = 'lib';

  /// 解析
  static String dartFile = '.dart';

  /// 模块的存放目录
  static String targetModuleTag = "packages";
  static String packages = "packages";
  static String rootUri = "rootUri";
  static String file = "file://";

  /// 目标目录
  static String targetPackageTag = 'init';

  /// 目标类文件
  static String targetSuperClassName = "ModuleLifecycle";

  static String dartToolTag=".dart_tool/package_config.json";

  /// 输出文件信息
  static String outputFilePath = "lib/generated/main_module_lifecycle.dart";
}

class ArgsVal {
  static String project = "project";
  static String outputFile = "outputFile";
  static String packages = "packages";
  static String pack = "pack";
}
