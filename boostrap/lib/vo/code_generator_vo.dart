class CodeGeneratorVo {
  final String packageInfo;
  final String className;
  final String path;

  CodeGeneratorVo(this.packageInfo, this.className,this.path);
}

extension ExtensionCodeGeneratorVo on List<CodeGeneratorVo>? {
  String get packages =>
      this?.fold(
          "",
          (previousValue, element) =>
              "${previousValue!}${previousValue.isEmpty ? '' : '\n'}import '${element.packageInfo}';") ??
      '';

  String get lifeCycles =>
      this?.fold(
          "",
          (previousValue, element) =>
              "${previousValue!}${previousValue.isEmpty ? '' : '\n'}    modules.add(${element.className}());") ??
      '';
}
