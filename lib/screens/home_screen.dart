import 'package:badminton_team_up/config/constants.dart';
import 'package:badminton_team_up/config/session.dart';
import 'package:badminton_team_up/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final List<String> playerNames = [];
  late Future<List<String>?> playerList;
  late bool toggleButton;
  final playersNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initPlayerData();
  }

  void _initPlayerData() async {
    playerList = Session.getStringList(Constants.playersListKey);
    var name = await playerList;
    playerNames.addAll([...name!]);
  }

  void _deletePlayer(int idx) async {
    setState(() {
      playerNames.removeAt(idx);
    });
    await Session.setStringList(Constants.playersListKey, playerNames);
  }

  Future<void> _showMyDialog(int idx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Player !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Player ${playerNames[idx]} will no longer be saved'),
                const Text('Are you sure to remove ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sure'),
              onPressed: () {
                _deletePlayer(idx);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void toggleTheme(WidgetRef ref) async {
    ref.read(isDarkThemeProvider.notifier).toggle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    toggleButton = ref.read(isDarkThemeProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
              value: toggleButton,
              onChanged: (val) async {
                await Session.setBool(Constants.isDarkKey, val);
                toggleTheme(ref);
              })
        ],
        title: Text(widget.title),
      ),
      // backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
            // color: Colors.black,
            // backgroundBlendMode: BlendMode.colorBurn,
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.png',
                ),
                fit: BoxFit.cover,
                opacity: 0.6)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _buildInputField(),
              const SizedBox(
                height: 35,
              ),
              FutureBuilder(
                future: playerList,
                builder: (context, snapshot) {
                  if (snapshot.hasData && playerNames.isNotEmpty) {
                    debugPrint("PlayerList >> ${snapshot.data}");
                    return _buildListView(context, playerNames);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          Text("Loading Players ...")
                        ],
                      ),
                    );
                  } else {
                    return Text(
                      "Add Players to Start\nBad Pairing !!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            for (double i = 1; i < 4; i++)
                              Shadow(
                                color: Colors.pinkAccent,
                                blurRadius: 5 * i,
                              )
                          ]),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                playerNames.shuffle();
                Constants.colors.shuffle();
                setState(() {});
              },
            )
          : null,
    );
  }

  TextField _buildInputField() {
    return TextField(
      // style: const TextStyle(color: Colors.white),
      controller: playersNameController,
      textAlign: TextAlign.justify,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          suffix: ElevatedButton(
              onPressed: () async {
                var enteredName = playersNameController.text.split(',');
                for (var i = 0; i < enteredName.length; i++) {
                  if (enteredName[i].contains(',')) {
                    enteredName.removeAt(i);
                  }
                }
                debugPrint("entered name >> $enteredName");

                setState(() {
                  if (enteredName.isNotEmpty) playerNames.addAll(enteredName);
                });
                await Session.setStringList(
                    Constants.playersListKey, playerNames);

                playersNameController.clear();
              },
              child: const Text('Add')),
          hintText: 'Ex:- Sourabh, Rohit, Bholu, ...',
          label: const Text("Player's Name"),
          // hintStyle: const TextStyle(color: Colors.white),
          // labelStyle: const TextStyle(color: Colors.white),
          // hoverColor: Colors.white,
          border: const OutlineInputBorder(
              // borderSide: BorderSide(color: Colors.white, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(21.0)))),
    );
  }

  Widget _buildListView(BuildContext context, List<String> names) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            names.length % 2 == 0 ? names.length ~/ 2 : names.length ~/ 2 + 1,
        separatorBuilder: ((context, index) {
          return const Divider(
            color: Colors.white,
            thickness: 1,
          );
        }),
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Team ${String.fromCharCode(65 + index)}',
                  style: const TextStyle(
                    // color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onLongPress: () => _showMyDialog(index * 2),
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: FittedBox(
                      child: Text(
                        names[index * 2],
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              for (double i = 1; i < 4; i++)
                                Shadow(
                                  color: index < Constants.colors.length
                                      ? Constants.colors[index]
                                      : Constants.colors[
                                          index % Constants.colors.length],
                                  blurRadius: 5 * i,
                                )
                            ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onLongPress: () {
                    index * 2 + 1 < names.length
                        ? _showMyDialog(index * 2 + 1)
                        : null;
                  },
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: FittedBox(
                      child: Text(
                        index * 2 + 1 < names.length
                            ? names[index * 2 + 1]
                            : '--',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              for (double i = 1; i < 4; i++)
                                Shadow(
                                  color: index < Constants.colors.length
                                      ? Constants.colors[index]
                                      : Constants.colors[
                                          index % Constants.colors.length],
                                  blurRadius: 5 * i,
                                )
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
