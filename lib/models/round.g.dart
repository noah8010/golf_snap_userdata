// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
  gameSessionId: json['game_session_id'] as String?,
  gameMode: json['game_mode'] as String,
  gameRule: json['game_rule'] as String,
  simulatorId: json['simulator_id'] as String?,
  roundId: json['round_id'] as String,
  userId: json['user_id'] as String,
  teamId: json['team_id'] as String?,
  playedAt: json['played_at'] as String,
  ccId: json['cc_id'] as String,
  ccName: json['cc_name'] as String?,
  courseId: json['course_id'] as String,
  courseName: json['course_name'] as String?,
  teeBox: json['tee_box'] as String,
  totalPar: (json['total_par'] as num).toInt(),
  totalScore: (json['total_score'] as num).toInt(),
  rank: (json['rank'] as num?)?.toInt(),
  rankingEligible: json['ranking_eligible'] as bool?,
  totalPutts: (json['total_putts'] as num).toInt(),
  fairwaysHit: (json['fairways_hit'] as num).toInt(),
  fairwaysAttempted: (json['fairways_attempted'] as num).toInt(),
  greensInRegulation: (json['greens_in_regulation'] as num).toInt(),
  mulligansUsed: (json['mulligans_used'] as num).toInt(),
  birdiesOrBetter: (json['birdies_or_better'] as num).toInt(),
  pars: (json['pars'] as num).toInt(),
  bogeys: (json['bogeys'] as num).toInt(),
  doubleBogeyOrWorse: (json['double_bogey_or_worse'] as num).toInt(),
  playEndTime: json['play_end_time'] as String?,
  holes: (json['holes'] as List<dynamic>)
      .map((e) => Hole.fromJson(e as Map<String, dynamic>))
      .toList(),
  shots: (json['shots'] as List<dynamic>)
      .map((e) => Shot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
  'game_session_id': instance.gameSessionId,
  'game_mode': instance.gameMode,
  'game_rule': instance.gameRule,
  'simulator_id': instance.simulatorId,
  'round_id': instance.roundId,
  'user_id': instance.userId,
  'team_id': instance.teamId,
  'played_at': instance.playedAt,
  'cc_id': instance.ccId,
  'cc_name': instance.ccName,
  'course_id': instance.courseId,
  'course_name': instance.courseName,
  'tee_box': instance.teeBox,
  'total_par': instance.totalPar,
  'total_score': instance.totalScore,
  'rank': instance.rank,
  'ranking_eligible': instance.rankingEligible,
  'total_putts': instance.totalPutts,
  'fairways_hit': instance.fairwaysHit,
  'fairways_attempted': instance.fairwaysAttempted,
  'greens_in_regulation': instance.greensInRegulation,
  'mulligans_used': instance.mulligansUsed,
  'birdies_or_better': instance.birdiesOrBetter,
  'pars': instance.pars,
  'bogeys': instance.bogeys,
  'double_bogey_or_worse': instance.doubleBogeyOrWorse,
  'play_end_time': instance.playEndTime,
  'holes': instance.holes,
  'shots': instance.shots,
};
