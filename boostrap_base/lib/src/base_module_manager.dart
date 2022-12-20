import 'package:boostrap_base/boostrap_base.dart';
import 'package:boostrap_base/src/module_generator.dart';

final moduleManager = BaseModuleManager();

class BaseModuleManager {
  static final List<BaseModuleInit> _modules = [];

  ///
  /// 初始化模块代码
  ///
  void initModule(ModuleGenerator generator) {
    _modules.addAll(generator.collectModules());
    try {
      for (var element in _modules) {
        element.init();
      }
    } catch (e) {
      print('exception:$e');
    }
  }
}
