// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hole.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hole _$HoleFromJson(Map<String, dynamic> json) => Hole(
  holeScoreId: json['hole_score_id'] as String,
  roundId: json['round_id'] as String,
  holeNumber: (json['hole_number'] as num).toInt(),
  holeId: json['hole_id'] as String,
  par: (json['par'] as num).toInt(),
  distance: (json['distance'] as num).toInt(),
  strokes: (json['strokes'] as num).toInt(),
  putts: (json['putts'] as num).toInt(),
  fairwayHit: json['fairway_hit'] as bool?,
  greenInRegulation: json['green_in_regulation'] as bool?,
  penalties: (json['penalties'] as num?)?.toInt() ?? 0,
  penaltyDetails: (json['penalty_details'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  firstPuttDistance: (json['first_putt_distance'] as num?)?.toDouble(),
  firstPuttMade: json['first_putt_made'] as bool?,
);

Map<String, dynamic> _$HoleToJson(Hole instance) => <String, dynamic>{
  'hole_score_id': instance.holeScoreId,
  'round_id': instance.roundId,
  'hole_number': instance.holeNumber,
  'hole_id': instance.holeId,
  'par': instance.par,
  'distance': instance.distance,
  'strokes': instance.strokes,
  'putts': instance.putts,
  'fairway_hit': instance.fairwayHit,
  'green_in_regulation': instance.greenInRegulation,
  'penalties': instance.penalties,
  'penalty_details': instance.penaltyDetails,
  'first_putt_distance': instance.firstPuttDistance,
  'first_putt_made': instance.firstPuttMade,
};
