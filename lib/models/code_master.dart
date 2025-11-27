import 'package:json_annotation/json_annotation.dart';

part 'code_master.g.dart';

@JsonSerializable()
class CodeMaster {
  @JsonKey(name: 'code_group')
  final String codeGroup;
  
  @JsonKey(name: 'code_id')
  final String codeId;
  
  @JsonKey(name: 'code_name')
  final String codeName;
  
  @JsonKey(name: 'code_desc')
  final String? codeDesc;

  CodeMaster({
    required this.codeGroup,
    required this.codeId,
    required this.codeName,
    this.codeDesc,
  });

  factory CodeMaster.fromJson(Map<String, dynamic> json) => _$CodeMasterFromJson(json);
  Map<String, dynamic> toJson() => _$CodeMasterToJson(this);
}
