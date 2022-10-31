import 'package:badminton_team_up/config/utils.dart';
import 'package:badminton_team_up/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';
import '../modals/possible_match_item.dart';

class PossibleMatches extends ConsumerStatefulWidget {
  PossibleMatches({Key? key}) : super(key: key);

  @override
  ConsumerState<PossibleMatches> createState() => _PossibleMatchesState();
}

class _PossibleMatchesState extends ConsumerState<PossibleMatches> {
  @override
  Widget build(BuildContext context) {
    final data = ref.read(teamProvider.notifier).possibleMatches();
    return Scaffold(
      appBar: AppBar(title: const Text("Possible Matches")),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: _buildPanel(data),
        ),
      )),
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

  Widget _buildPanel(data) {
    return ExpansionPanelList.radio(
      children: data.map<ExpansionPanelRadio>((TeamItem item) {
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
                            keyboardType: TextInputType.number,
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
