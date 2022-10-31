// stores ExpansionPanel state information
class TeamItem {
  TeamItem({
    required this.expandedValue,
    required this.teamAlpha,
    required this.playerAlpha1,
    required this.playerAlpha2,
    required this.teamBeta,
    required this.playerBeta1,
    required this.playerBeta2,
    required this.id,
  });

  String expandedValue;
  String teamAlpha;
  String playerAlpha1;
  String playerAlpha2;
  String teamBeta;
  String playerBeta1;
  String playerBeta2;
  int id;
}
