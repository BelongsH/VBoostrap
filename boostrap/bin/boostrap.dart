import 'dart:io';

import 'package:args/args.dart';
import 'package:boostrap/config/cons_val.dart';
import 'package:path/path.dart' as path;
import 'package:boostrap/module_core_executor.dart';
import 'package:boostrap/vo/plugin_vo.dart';

void main(List<String> arguments) {
  var parser = ArgParser();

  /// 需要扫描的主项目
  parser.addOption(ArgsVal.project,
      defaultsTo: Directory.current.path, abbr: 'p');

  /// 需要输出的文件夹
  parser.addOption(ArgsVal.outputFile,
      defaultsTo: Directory.current.path, abbr: 'o');

  /// 需要扫描的模块信息
  parser.addOption(ArgsVal.packages,
      defaultsTo: ConsVal.targetModuleTag, abbr: 'm');

  /// 目标包信息
  parser.addOption(ArgsVal.pack,
      defaultsTo: ConsVal.targetPackageTag, abbr: 'd');

  final result = parser.parse(arguments);
  String argPath = result[ArgsVal.project];
  String moduleTag = result[ArgsVal.packages];
  String packageTag = result[ArgsVal.pack];
  String outputFile =
      path.join(result[ArgsVal.outputFile], ConsVal.outputFilePath);

  print('       ------------插件扫描解析开始------------    ');

  String info = """
  解析项目:$argPath      
  生成文件路径:$outputFile 
  过滤模块标识:$moduleTag    
  扫描包的标识:$packageTag 
  """;
  print(info);

  ///  根目录信息
  ModuleCoreExecutor(
    extra: PluginVo(argPath, outputFile, moduleTag, packageTag),
  ).doExecute();
}
