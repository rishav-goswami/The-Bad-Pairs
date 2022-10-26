import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamNotifier extends StateNotifier<List<Map<String, List<String>>>> {
  TeamNotifier() : super([]);

  void addTeams(List<String> createdTeams) {
    List<Map<String, List<String>>> tempTeams = [];

    state.clear();
    for (int i = 0;
        i <
            (createdTeams.length % 2 == 0
                ? createdTeams.length ~/ 2
                : createdTeams.length ~/ 2 + 1);
        i++) {
      List<String> tempPlayers = [];
      Map<String, List<String>> tempTeam = {};
      tempPlayers.addAll([
        createdTeams[i * 2],
        i * 2 + 1 < createdTeams.length ? createdTeams[i * 2 + 1] : '--'
      ]);
      tempTeam['Team ${String.fromCharCode(65 + i)}'] = tempPlayers;
      tempTeams.add(tempTeam);
    }
    debugPrint("Generated Teams : $tempTeams");
    state.addAll(tempTeams);
  }
}

final teamProvider =
    StateNotifierProvider<TeamNotifier, List<Map<String, List<String>>>>((ref) {
  return TeamNotifier();
});
