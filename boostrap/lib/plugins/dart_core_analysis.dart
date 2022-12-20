import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:boostrap/config/cons_val.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:boostrap/template/generator_code_template.dart';
import 'package:boostrap/visitor/model_visitor.dart';
import 'package:boostrap/vo/code_generator_vo.dart';

// AST
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
