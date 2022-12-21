class ConsVal {
  ///需要解析的包路径
  static String coreLib = 'lib';

  /// 解析
  static String dartFile = '.dart';

  /// 模块的存放目录
  static String targetModuleTag = "module";

  /// 解析包的json
  static String jsonPackages = "packages";
  static String jsonRootUri = "rootUri";
  static String jsonFile = "file://";

  /// 目标目录
  static String targetPackageTag = 'init';

  /// 目标类文件
  static String targetSuperClassName = "ModuleLifecycle";

  /// 解析文件信息
  static String packageJsonTag = ".dart_tool/package_config.json";
  static String dartToolTag = ".dart_tool";

  /// 输出文件信息
  static String outputFilePath = "lib/generated/main_module_lifecycle.dart";
}

class ArgsVal {
  static String project = "project";
  static String outputFile = "outputFile";
  static String packages = "packages";
  static String pack = "pack";
}
