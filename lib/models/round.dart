import 'package:json_annotation/json_annotation.dart';
import 'hole.dart';
import 'shot.dart';

part 'round.g.dart';

@JsonSerializable()
class Round {
  @JsonKey(name: 'game_session_id')
  final String? gameSessionId;
  
  @JsonKey(name: 'game_mode')
  final String gameMode;
  
  @JsonKey(name: 'game_rule')
  final String gameRule;
  
  @JsonKey(name: 'simulator_id')
  final String? simulatorId;
  
  @JsonKey(name: 'round_id')
  final String roundId;
  
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'team_id')
  final String? teamId;
  
  @JsonKey(name: 'played_at')
  final String playedAt;
  
  @JsonKey(name: 'cc_id')
  final String ccId;

  @JsonKey(name: 'cc_name')
  final String? ccName;
  
  @JsonKey(name: 'course_id')
  final String courseId;

  @JsonKey(name: 'course_name')
  final String? courseName;
  
  @JsonKey(name: 'tee_box')
  final String teeBox;
  
  @JsonKey(name: 'total_par')
  final int totalPar;
  
  @JsonKey(name: 'total_score')
  final int totalScore;
  
  final int? rank;
  
  @JsonKey(name: 'ranking_eligible')
  final bool? rankingEligible;
  
  @JsonKey(name: 'total_putts')
  final int totalPutts;
  
  @JsonKey(name: 'fairways_hit')
  final int fairwaysHit;
  
  @JsonKey(name: 'fairways_attempted')
  final int fairwaysAttempted;
  
  @JsonKey(name: 'greens_in_regulation')
  final int greensInRegulation;
  
  @JsonKey(name: 'mulligans_used')
  final int mulligansUsed;
  
  @JsonKey(name: 'birdies_or_better')
  final int birdiesOrBetter;
  
  final int pars;
  final int bogeys;
  
  @JsonKey(name: 'double_bogey_or_worse')
  final int doubleBogeyOrWorse;
  
  @JsonKey(name: 'play_end_time')
  final String? playEndTime;
  
  final List<Hole> holes;
  final List<Shot> shots;

  Round({
    this.gameSessionId,
    required this.gameMode,
    required this.gameRule,
    this.simulatorId,
    required this.roundId,
    required this.userId,
    this.teamId,
    required this.playedAt,
    required this.ccId,
    this.ccName,
    required this.courseId,
    this.courseName,
    required this.teeBox,
    required this.totalPar,
    required this.totalScore,
    this.rank,
    this.rankingEligible,
    required this.totalPutts,
    required this.fairwaysHit,
    required this.fairwaysAttempted,
    required this.greensInRegulation,
    required this.mulligansUsed,
    required this.birdiesOrBetter,
    required this.pars,
    required this.bogeys,
    required this.doubleBogeyOrWorse,
    this.playEndTime,
    required this.holes,
    required this.shots,
  });

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}
