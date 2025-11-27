import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/round.dart';
import '../models/code_master.dart';

class AssetRepository {
  static const String _roundsPath = 'assets/data/all_sample_rounds.json';
  static const String _codeMasterPath = 'assets/data/code_master_data.json';

  Future<List<Round>> loadRounds() async {
    try {
      final String jsonString = await rootBundle.loadString(_roundsPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Round.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading rounds: $e');
      return [];
    }
  }

  Future<List<CodeMaster>> loadCodeMasters() async {
    try {
      final String jsonString = await rootBundle.loadString(_codeMasterPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CodeMaster.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading code masters: $e');
      return [];
    }
  }
}
