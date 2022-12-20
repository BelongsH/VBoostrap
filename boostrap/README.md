##### 前言

在`Flutter`多模块开发中，会重复在`Example`去初始化基础模块的一些操作。比如说`多语言`的配置。`路由`的初始化。能否将这些模块功能在对应模块，就进行初始化。这样子不需要每次`主模块`感知到到底需要初始化多少功能模块。



##### 使用

`boostrap`是在编译期，对项目插件进行扫描。对应生成`MainModuleGenerator`类，来存放收集到符合模块初始化的信息。在使用`boostrap`的时候，需要将`boostrap`安装到`path`中

```dart
dart pub global activate --source git https://github.com/BelongsH/VBoostrap.git --git-path boostrap/
```

这样子，你就可以使用`boostrap`的功能了。 `boostrap`可解析的参数如下

```shell
--p /// 需要扫描的主项目路径
--o /// 需要输出的文件夹路径
--m /// 需要扫描的模块信息，用于过滤
--d /// 目标包信息，用于过滤
```

默认直接执行`boostrap`的话,会获取到当前的项目路径。然后扫描当前工程下，所依赖的插件信息。可以配置根据上面的参数进行配置。

```shell
boostrap --p projectPath --o outputFilePath --m filterModule --d filterPackageInfo
```

我们的模块都是在`packages`包下，所以`--m filterModule`会加快代码的扫描，从而过滤一下官方、和其他一些第三方的插件信息。

当然`--d filterPackageInfo` 也是属于这个作用，他会加快过滤收集需要初始化的文件信息。我们也是将需要初始化都放在`init`文件夹中。

以上你都不进行配置的时候。默认`filterModule` 就是`packages` ，`filterPackageInfo`就是`init`，你只需要遵循约定大于配置的道理。将需要初始化的类放在`init`文件夹，模块信息放在`packages`下即可。

以下是执行`boostrap`命令后的返回

![image-20221220162121319](/Users/liuhuiliang/Library/Application Support/typora-user-images/image-20221220162121319.png)

可以看到在主工程中生成一个`MainModuleGenerator`文件。然后你只需要将这个`MainModuleGenerator`初始化即可。

```dart
BaseModuleManager.initModule(MainModuleGenerator());
```

如果你是一个模块的编写者，在编写模块的时候，希望模块能够感知到`APP`启动这个回调，你需要继承至`BaseModuleInit`然后重新其中的`init`方法。

以下是当`APP`启动的时候，合并多个模块的语言文件

```dart
import 'package:boostrap_base/boostrap_base.dart';
import 'package:module_base/l10n/vv_message_look_up.dart';
import 'package:intl/src/intl_helpers.dart';

class MultiLanguageLoopUpInit extends BaseModuleInit {
  @override
  void init() {
    messageLookup = VvMessageLookup();
  }
}

```



##### 原理分析

![hello](/Users/liuhuiliang/Documents/MyGitHub/boostrap/hello.png)

代码的实现思路，在`主项目`中获取到子项目的插件信息。并且分析插件内符合条件的类、在分析符合条件的类的时候，考虑到项目工程所有的代码转`ast`的时间非常耗时。所以需要过滤到一些无效的包信息。使用命令行就可以有效的过滤信息

以下是解析命令行参数信息代码。

```dart
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
```

解析完命令行信息，需要将`dart`代码转化成`ast`从而可以得知复合条件的类。然后进行收集。

以下是判断复合条件的类的核心代码。

```dart
class ModelVisitor extends SimpleElementVisitor {
  final List<CodeGeneratorVo> codeGenerators = [];

  late String targetValue = (BaseModuleInit).toString();

  @override
  visitConstructorElement(ConstructorElement element) {}

  @override
  visitClassElement(ClassElement element) {
    if (element.supertype != null && element.isType(targetValue)) {
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
```

然后将复合条件类的信息合并后并且生成一个特定的类文件。方便让主工程进行调用。

以下是生成代码的核心逻辑。

```dart
class DartCoreAnalysis {
  final ModelVisitor _modelVisitor = ModelVisitor();

  void classVisitor(List<String> includedPaths) async {
    final collection = AnalysisContextCollection(includedPaths: includedPaths);
    for (String path in includedPaths) {
      AnalysisContext context = collection.contextFor(path);
      AnalysisSession session = context.currentSession;
      var result = await session.getUnitElement(path);
      if (result is UnitElementResult) {
        CompilationUnitElement element = result.element;
        element.visitChildren(_modelVisitor);
      }
    }

    Map formatCode = {};
    formatCode['importMessage'] = _modelVisitor.codeGenerators.packages;
    formatCode['initCode'] = _modelVisitor.codeGenerators.lifeCycles;
    final apiOutput = Template(code).renderString(formatCode);
    File(ConsVal.outputFilePath)
      ..createSync(recursive: true)
      ..writeAsString(apiOutput, flush: true);
    for (var element in files) {
      print('---------------- 自动生成:$element ');
    }
  }

  List<String> get files =>
      _modelVisitor.codeGenerators.map((e) => e.path).toList();
}
```



