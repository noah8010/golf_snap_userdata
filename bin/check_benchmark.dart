import 'dart:convert';
import 'dart:io';

import 'package:golf_stats_app/models/benchmark_stats.dart';
import 'package:golf_stats_app/models/round.dart';
import 'package:golf_stats_app/repositories/benchmark_repository.dart';

Future<void> main(List<String> args) async {
  final roundsFile = File('assets/data/all_sample_rounds.json');

  if (!roundsFile.existsSync()) {
    stderr.writeln('❌ rounds file not found: ${roundsFile.path}');
    exit(1);
  }

  final jsonList = json.decode(await roundsFile.readAsString()) as List<dynamic>;
  final rounds = jsonList.map((e) => Round.fromJson(e as Map<String, dynamic>)).toList();

  final repo = BenchmarkRepository();
  final benchmark = repo.calculateBenchmark(rounds);

  void logAggregate(String label, AggregateStats stats) {
    stdout.writeln('--- $label ---');
    stdout.writeln('Avg Score   : ${stats.averageScore.toStringAsFixed(1)}');
    stdout.writeln('Avg Putts   : ${stats.averagePutts.toStringAsFixed(1)}');
    stdout.writeln('Driver Dist : ${stats.driverDistance.toStringAsFixed(1)}');
    stdout.writeln('Fairway %   : ${stats.fairwayAccuracy.toStringAsFixed(1)}');
    stdout.writeln('GIR %       : ${stats.girPercentage.toStringAsFixed(1)}');
    stdout.writeln('3-Putt %    : ${stats.threePuttRate.toStringAsFixed(1)}');
    stdout.writeln('');
  }

  stdout.writeln('총 라운드 수: ${rounds.length}');
  logAggregate('Overall', benchmark.overall);
  logAggregate('Top 10%', benchmark.top10);
  logAggregate('Bottom 10%', benchmark.bottom10);

  stdout.writeln('분포 데이터 크기');
  stdout.writeln('Scores  : ${benchmark.scoreDistribution.length}');
  stdout.writeln('Fairway : ${benchmark.fairwayDistribution.length}');
  stdout.writeln('Driver  : ${benchmark.driverDistanceDistribution.length}');
  stdout.writeln('Putts   : ${benchmark.puttsDistribution.length}');
  stdout.writeln('GIR     : ${benchmark.girDistribution.length}');
}

