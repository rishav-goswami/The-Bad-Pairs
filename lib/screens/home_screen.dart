import 'package:badminton_team_up/config/constants.dart';
import 'package:badminton_team_up/config/session.dart';
import 'package:badminton_team_up/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the type used by the popup menu below.
enum Menu { deleteAll, itemTwo, itemThree, itemFour }

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
  String _selectedMenu = '';

  @override
  void initState() {
    super.initState();
    _initPlayerData();
  }

// Initializing Player data from shared Pref
  void _initPlayerData() async {
    playerList = Session.getStringList(Constants.playersListKey);
    var name = await playerList;
    debugPrint("_initPlayerData called : $name");
    if (name != null) {
      playerNames.clear();
      playerNames.addAll([...name]);
    }
  }

//  adding entered player
  _addPlayers() async {
    final enteredText = playersNameController.text;
    if (enteredText.isNotEmpty) {
      var enteredNames = enteredText.split(',');
      for (var i = 0; i < enteredNames.length; i++) {
        if (enteredNames[i].contains(',')) {
          enteredNames.removeAt(i);
        }
      }

      debugPrint("entered names[] : $enteredNames");

      setState(() {
        if (enteredNames.isNotEmpty) playerNames.addAll(enteredNames);
      });

      await Session.setStringList(Constants.playersListKey, playerNames);
      if ((await playerList) == null) {
        _initPlayerData();
      }
    }
    playersNameController.clear();
  }

  // To update/edit player name showing bottom model sheet
  Future<void> _showBottomSheet(int idx, BuildContext context) async {
    return showModalBottomSheet(
        clipBehavior: Clip.none,
        context: context,
        elevation: 8,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildNeonLightText(context, ["The Bad Pairs !"], 0, true),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Update Player's name !"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    textInputAction: TextInputAction.done,
                    onSubmitted: (val) async {
                      playerNames.setAll(idx, [val]);
                      await Session.setStringList(
                          Constants.playersListKey, playerNames);
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      label: const Text("Edit Player name"),
                      hintText: playerNames[idx],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// TO delete a single player on long_press on it
  void _deletePlayer(int idx) async {
    setState(() {
      playerNames.removeAt(idx);
    });
    await Session.setStringList(Constants.playersListKey, playerNames);
  }

// To delete all teams of players
  void _deleteAllPlayers() async {
    await Session.deletePrefData(Constants.playersListKey);
    setState(() {
      playerNames.clear();
    });
  }

  // Confirmation dialog box for deletion of player
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

  // Function to toggle between light and dark theme
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
              }),
          // This button presents popup menu items.
          PopupMenuButton<Menu>(
              // Callback that sets the selected popup menu item.
              onSelected: (Menu item) {
                setState(() {
                  _selectedMenu = item.name;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.deleteAll,
                      onTap: _deleteAllPlayers,
                      child: const Text('Delete All Teams'),
                    ),
                    // const PopupMenuItem<Menu>(
                    //   value: Menu.itemTwo,
                    //   child: Text('Item 2'),
                    // ),
                    // const PopupMenuItem<Menu>(
                    //   value: Menu.itemThree,
                    //   child: Text('Item 3'),
                    // ),
                    // const PopupMenuItem<Menu>(
                    //   value: Menu.itemFour,
                    //   child: Text('Item 4'),
                    // ),
                  ]),
        ],
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
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

//  Input area to take player names as input
  TextField _buildInputField() {
    return TextField(
      controller: playersNameController,
      textAlign: TextAlign.justify,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          suffix: ElevatedButton(
              onPressed: () => _addPlayers(), child: const Text('Add')),
          hintText: 'Ex:- Sourabh, Rohit, Bholu, ...',
          label: const Text("Player's Name"),
          border: const OutlineInputBorder(
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _showBottomSheet(index * 2, context),
                  onLongPress: () => _showMyDialog(index * 2),
                  child: _buildNeonLightText(context, names, index, true),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => _showBottomSheet(index * 2 + 1, context),
                  onLongPress: () {
                    index * 2 + 1 < names.length
                        ? _showMyDialog(index * 2 + 1)
                        : null;
                  },
                  child: _buildNeonLightText(context, names, index, false),
                ),
              ],
            ),
          );
        }));
  }

//  To build and return colorful neon light effect text according to position
  SizedBox _buildNeonLightText(
      BuildContext context, List<String> names, int index, bool isFirst) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.30,
      child: FittedBox(
        child: Text(
          isFirst
              ? names[index * 2]
              : (index * 2 + 1 < names.length ? names[index * 2 + 1] : '--'),
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
}
