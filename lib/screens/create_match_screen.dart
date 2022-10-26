import 'package:badminton_team_up/config/utils.dart';
import 'package:badminton_team_up/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PossibleMatches extends ConsumerStatefulWidget {
  PossibleMatches({Key? key}) : super(key: key);

  @override
  ConsumerState<PossibleMatches> createState() => _PossibleMatchesState();
}

class _PossibleMatchesState extends ConsumerState<PossibleMatches> {
  @override
  Widget build(BuildContext context) {
    final allTeams = ref.watch(teamProvider);
    final data = _possibleMatches(allTeams);
    return Scaffold(
      appBar: AppBar(title: const Text("Possible Matches")),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length % 2 == 0
                  ? data.length ~/ 2
                  : data.length ~/ 2 + 1,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text(data[index * 2].values.first.first),
                        Text(data[index * 2].values.first.last),
                      ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(data[index * 2 + 1].values.first.first),
                            Text(data[index * 2 + 1].values.first.last),
                          ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  _possibleMatches(var listOfTeams) {
    var possibleTeams =
        Utils.printCombination(listOfTeams, listOfTeams.length, 2);
    debugPrint("Generated Matches : $possibleTeams");
    return possibleTeams;
  }
}
