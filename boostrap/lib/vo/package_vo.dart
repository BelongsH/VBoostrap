import 'package:boostrap/config/cons_val.dart';

class PackageVo {
  String? name;
  String? rootUri;

  String get filePath => rootUri?.replaceAll(ConsVal.jsonFile, "") ?? '';

  PackageVo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rootUri = json['rootUri'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'rootUri': rootUri,
      };
}
