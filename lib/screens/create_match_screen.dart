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
  // final List<TeamItem> _data = generateItems(4);
  @override
  Widget build(BuildContext context) {
    final data = ref.read(teamProvider.notifier).possibleMatches();
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
                  child: Card(
                    shadowColor: index < Constants.colors.length
                        ? Constants.colors[index]
                        : Constants.colors[index % Constants.colors.length],
                    elevation: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          _buildNeonLightText(
                              context, data[index * 2].keys.first, index * 2),
                          Text(data[index * 2].values.first.first),
                          Text(data[index * 2].values.first.last),
                        ]),
                        const Text('Vs'),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNeonLightText(
                                  context,
                                  data[index * 2 + 1].keys.first,
                                  index * 2 + 1),
                              Text(data[index * 2 + 1].values.first.first),
                              Text(data[index * 2 + 1].values.first.last),
                            ]),
                      ],
                    ),
                  ),
                );
              },
            ),

            // _buildPanel()
          ],
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

  // Widget _buildPanel() {
  //   return ExpansionPanelList.radio(
  //     initialOpenPanelValue: 2,
  //     children: _data.map<ExpansionPanelRadio>((TeamItem item) {
  //       return ExpansionPanelRadio(
  //           value: item.id,
  //           headerBuilder: (BuildContext context, bool isExpanded) {
  //             return ListTile(
  //               title: Text(item.headerValue),
  //             );
  //           },
  //           body: ListTile(
  //               title: Text(item.expandedValue),
  //               subtitle:
  //                   const Text('To delete this panel, tap the trash can icon'),
  //               trailing: const Icon(Icons.delete),
  //               onTap: () {
  //                 setState(() {
  //                   _data.removeWhere(
  //                       (TeamItem currentItem) => item == currentItem);
  //                 });
  //               }));
  //     }).toList(),
  //   );
  // }

}
