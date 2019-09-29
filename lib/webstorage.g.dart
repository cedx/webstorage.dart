// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webstorage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleChange _$SimpleChangeFromJson(Map<String, dynamic> json) {
  return SimpleChange(
    currentValue: json['currentValue'] as String,
    previousValue: json['previousValue'] as String,
  );
}

Map<String, dynamic> _$SimpleChangeToJson(SimpleChange instance) =>
    <String, dynamic>{
      'currentValue': instance.currentValue,
      'previousValue': instance.previousValue,
    };
