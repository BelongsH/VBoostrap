import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:boostrap/vo/code_generator_vo.dart';
import 'package:boostrap_base/boostrap_base.dart';
import 'package:collection/collection.dart';

//https://github.com/Pierre2tm/dotfiles/blob/fd4cd412d8/macos/User/History/7fa76eb8/LJU6.dart
class ModelVisitor extends SimpleElementVisitor {
  final List<CodeGeneratorVo> codeGenerators = [];

  late String targetValue = (BaseModuleInit).toString();

  static const methodName = "init";

  @override
  visitConstructorElement(ConstructorElement element) {}

  @override
  visitClassElement(ClassElement element) {
    if (element.supertype != null && (element.isType(targetValue)) ||
        (element.methods.map((e) => e.name).contains(methodName))) {
      final packageName = element.location?.components.firstOrNull;
      if (packageName != null && packageName.isNotEmpty) {
        final path = element.enclosingElement.source.fullName;
        if (!codeGenerators
            .any((element) => element.packageInfo == packageName)) {
          codeGenerators
              .add(CodeGeneratorVo(packageName, element.displayName, path));
        }
      }
    }
    return super.visitClassElement(element);
  }
}

extension ClassElementExt on ClassElement {
  bool isType(String name) {
    return allSupertypes.any((superType) => superType.element.name == name);
  }
}
