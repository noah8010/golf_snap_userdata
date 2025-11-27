import 'package:json_annotation/json_annotation.dart';

part 'shot.g.dart';

@JsonSerializable()
class Shot {
  @JsonKey(name: 'shot_id')
  final String shotId;
  
  @JsonKey(name: 'hole_score_id')
  final String holeScoreId;
  
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'shot_number')
  final int shotNumber;
  
  @JsonKey(name: 'club_type')
  final String clubType;
  
  @JsonKey(name: 'shot_type')
  final String shotType;
  
  final String lie;
  
  @JsonKey(name: 'is_putt')
  final bool isPutt;
  
  @JsonKey(name: 'putt_made')
  final bool? puttMade;
  
  @JsonKey(name: 'putt_length')
  final double? puttLength;
  
  @JsonKey(name: 'is_mulligan')
  final bool isMulligan;
  
  @JsonKey(name: 'shot_at')
  final String? shotAt;
  
  // Shot Metrics
  @JsonKey(name: 'TOTAL')
  final double? totalDistance;
  
  @JsonKey(name: 'CARRY')
  final double? carryDistance;
  
  @JsonKey(name: 'HEIGHT')
  final double? height;
  
  @JsonKey(name: 'LAND_ANG')
  final double? landAngle;
  
  @JsonKey(name: 'SIDE')
  final double? sideDeviation;
  
  @JsonKey(name: 'SIDE_TOT')
  final double? sideTotal;
  
  @JsonKey(name: 'HANG_TIME')
  final double? hangTime;
  
  @JsonKey(name: 'FROM_PIN')
  final double? fromPin;

  // Sensor Data (Ball)
  @JsonKey(name: 'BALL_SPEED')
  final double? ballSpeed;
  
  @JsonKey(name: 'LAUNCH_ANG')
  final double? launchAngle;
  
  @JsonKey(name: 'LAUNCH_DIR')
  final double? launchDirection;
  
  @JsonKey(name: 'SPIN_RATE')
  final double? spinRate;
  
  @JsonKey(name: 'SPIN_AXIS')
  final double? spinAxis;
  
  @JsonKey(name: 'BACK_SPIN')
  final double? backSpin;
  
  @JsonKey(name: 'SIDE_SPIN')
  final double? sideSpin;
  
  @JsonKey(name: 'SMASH_FAC')
  final double? smashFactor;

  // Sensor Data (Club)
  @JsonKey(name: 'ATTACK_ANG')
  final double? attackAngle;
  
  @JsonKey(name: 'CLUB_PATH')
  final double? clubPath;
  
  @JsonKey(name: 'DYN_LOFT')
  final double? dynamicLoft;
  
  @JsonKey(name: 'SPIN_LOFT')
  final double? spinLoft;
  
  @JsonKey(name: 'FACE_ANG')
  final double? faceAngle;
  
  @JsonKey(name: 'FACE_TO_PATH')
  final double? faceToPath;
  
  @JsonKey(name: 'CLUB_SPEED')
  final double? clubSpeed;

  Shot({
    required this.shotId,
    required this.holeScoreId,
    required this.userId,
    required this.shotNumber,
    required this.clubType,
    required this.shotType,
    required this.lie,
    required this.isPutt,
    this.puttMade,
    this.puttLength,
    this.isMulligan = false,
    this.shotAt,
    this.totalDistance,
    this.carryDistance,
    this.height,
    this.landAngle,
    this.sideDeviation,
    this.sideTotal,
    this.hangTime,
    this.fromPin,
    this.ballSpeed,
    this.launchAngle,
    this.launchDirection,
    this.spinRate,
    this.spinAxis,
    this.backSpin,
    this.sideSpin,
    this.smashFactor,
    this.attackAngle,
    this.clubPath,
    this.dynamicLoft,
    this.spinLoft,
    this.faceAngle,
    this.faceToPath,
    this.clubSpeed,
  });

  factory Shot.fromJson(Map<String, dynamic> json) => _$ShotFromJson(json);
  Map<String, dynamic> toJson() => _$ShotToJson(this);
}
