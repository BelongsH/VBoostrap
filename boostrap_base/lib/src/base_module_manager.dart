import 'package:boostrap_base/boostrap_base.dart';
import 'package:boostrap_base/src/module_generator.dart';

class BaseModuleManager {
  static final List<BaseModuleInit> _modules = [];

  ///
  /// 初始化模块代码
  ///
  static Future initModule(ModuleGenerator generator) {
    _modules.addAll(generator.collectModules());
    try {
      return Future.forEach(_modules, (element) async {
        await element.init();
      });
    } catch (e) {
      print('exception:$e');
      return Future.value();
    }
  }
}
