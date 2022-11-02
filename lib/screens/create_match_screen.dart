import 'package:badminton_team_up/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';
import '../modals/possible_match_item.dart';

class PossibleMatches extends ConsumerStatefulWidget {
  const PossibleMatches({Key? key}) : super(key: key);

  @override
  ConsumerState<PossibleMatches> createState() => _PossibleMatchesState();
}

class _PossibleMatchesState extends ConsumerState<PossibleMatches> {
  late final List<TeamItem> _possibleMatchData;
  late final List<int> teamScores;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    final allTeams = ref.read(teamProvider);
    // Initializing only once
    if (flag) {
      flag = false;
      teamScores = List<int>.filled(allTeams.length, 0);
      _possibleMatchData = ref.read(teamProvider.notifier).possibleMatches();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Matches & Scores")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Scoreboard",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Divider(
                indent: 30,
                endIndent: 30,
                thickness: 3,
                color: Colors.amber,
              ),
              ListView.separated(
                  itemCount: allTeams.length,
                  shrinkWrap: true,
                  separatorBuilder: ((context, index) => const Divider(
                        thickness: 1,
                      )),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  _buildNeonLightText(context,
                                      allTeams[index].keys.first, index),
                                  Text(allTeams[index].values.first.first),
                                  Text(allTeams[index].values.first.last)
                                ],
                              ),
                              Text(
                                "Score ${teamScores[index]}",
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Possible Matches",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Divider(
                indent: 30,
                endIndent: 30,
                thickness: 3,
                color: Colors.amber,
              ),
              _buildPanel(),
            ],
          ),
        ),
      ),
    );
  }

//  To build and return colorful neon light effect text according to position
  SizedBox _buildNeonLightText(BuildContext context, String text, int index) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.30,
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              shadows: [
                for (double i = 1; i < 4; i++)
                  Shadow(
                    color: index < Constants.colors.length
                        ? Constants.colors[index]
                        : Constants.colors[index % Constants.colors.length],
                    blurRadius: 5 * i,
                  )
              ]),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      children: _possibleMatchData.map<ExpansionPanelRadio>((TeamItem item) {
        return ExpansionPanelRadio(
            // backgroundColor: item.id < Constants.colors.length
            //     ? Constants.colors[item.id]
            //     : Constants.colors[item.id % Constants.colors.length],
            value: item.id,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      _buildNeonLightText(context, item.teamAlpha, item.id * 2),
                      Text(item.playerAlpha1),
                      Text(item.playerAlpha2),
                    ]),
                    const Text('Vs'),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNeonLightText(
                              context, item.teamBeta, item.id * 2 + 1),
                          Text(item.playerBeta1),
                          Text(item.playerBeta2),
                        ]),
                  ],
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text("Alpha_Score"),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onSubmitted: ((value) {
                              // setState(() {
                              //   teamScores[item.id * 2] = int.parse(value);
                              // });
                            }),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Beta_Score"),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            onSubmitted: ((value) {
                              // setState(() {
                              //   teamScores[item.id * 2] = int.parse(value);
                              // });
                            }),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                        )
                      ],
                    ),
                  ]),
            ));
      }).toList(),
    );
  }
}
