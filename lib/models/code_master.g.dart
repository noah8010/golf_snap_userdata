// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeMaster _$CodeMasterFromJson(Map<String, dynamic> json) => CodeMaster(
  codeGroup: json['code_group'] as String,
  codeId: json['code_id'] as String,
  codeName: json['code_name'] as String,
  codeDesc: json['code_desc'] as String?,
);

Map<String, dynamic> _$CodeMasterToJson(CodeMaster instance) =>
    <String, dynamic>{
      'code_group': instance.codeGroup,
      'code_id': instance.codeId,
      'code_name': instance.codeName,
      'code_desc': instance.codeDesc,
    };
