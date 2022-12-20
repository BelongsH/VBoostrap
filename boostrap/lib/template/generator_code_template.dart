String code = """
import 'package:boostrap_base/src/base_module_init.dart';
import 'package:boostrap_base/src/module_generator.dart';
{{{importMessage}}}
class MainModuleGenerator extends ModuleGenerator {
    @override
  List<BaseModuleInit> collectModules() {
    final List<BaseModuleInit> modules=[];
{{{initCode}}}
    return modules;
  }
}
""";




