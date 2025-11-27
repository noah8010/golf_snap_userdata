import 'package:json_annotation/json_annotation.dart';

part 'hole.g.dart';

@JsonSerializable()
class Hole {
  @JsonKey(name: 'hole_score_id')
  final String holeScoreId;
  
  @JsonKey(name: 'round_id')
  final String roundId;
  
  @JsonKey(name: 'hole_number')
  final int holeNumber;
  
  @JsonKey(name: 'hole_id')
  final String holeId;
  
  final int par;
  final int distance;
  final int strokes;
  final int putts;
  
  @JsonKey(name: 'fairway_hit')
  final bool? fairwayHit;
  
  @JsonKey(name: 'green_in_regulation')
  final bool? greenInRegulation;
  
  final int penalties;
  
  @JsonKey(name: 'penalty_details')
  final List<String>? penaltyDetails;
  
  @JsonKey(name: 'first_putt_distance')
  final double? firstPuttDistance;
  
  @JsonKey(name: 'first_putt_made')
  final bool? firstPuttMade;

  Hole({
    required this.holeScoreId,
    required this.roundId,
    required this.holeNumber,
    required this.holeId,
    required this.par,
    required this.distance,
    required this.strokes,
    required this.putts,
    this.fairwayHit,
    this.greenInRegulation,
    this.penalties = 0,
    this.penaltyDetails,
    this.firstPuttDistance,
    this.firstPuttMade,
  });

  factory Hole.fromJson(Map<String, dynamic> json) => _$HoleFromJson(json);
  Map<String, dynamic> toJson() => _$HoleToJson(this);
}
