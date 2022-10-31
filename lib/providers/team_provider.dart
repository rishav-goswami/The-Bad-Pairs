import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/utils.dart';
import '../modals/possible_match_item.dart';

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

  List<TeamItem> possibleMatches() {
    var possibleTeams = Utils.getCombination(state, state.length, 2);
    debugPrint("Generated Matches : $possibleTeams");
    return _generateItems(possibleTeams);
  }

  List<TeamItem> _generateItems(var data) {
    return List<TeamItem>.generate(
        data.length % 2 == 0 ? data.length ~/ 2 : data.length ~/ 2 + 1,
        (int index) {
      return TeamItem(
        id: index,
        teamAlpha: data[index * 2].keys.first,
        playerAlpha1: data[index * 2].values.first.first,
        playerAlpha2: data[index * 2].values.first.last,
        teamBeta: data[index * 2 + 1].keys.first,
        playerBeta1: data[index * 2 + 1].values.first.first,
        playerBeta2: data[index * 2 + 1].values.first.last,
        expandedValue: 'This is item number $index',
      );
    });
  }
}

final teamProvider =
    StateNotifierProvider<TeamNotifier, List<Map<String, List<String>>>>((ref) {
  return TeamNotifier();
});
