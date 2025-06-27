import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class ScorecardScreen extends StatefulWidget {
  final String matchId;

  const ScorecardScreen({super.key, required this.matchId});

  @override
  State<StatefulWidget> createState() => ScorecordScreenState();
}

int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class ScorecordScreenState extends State<ScorecardScreen>
    with SingleTickerProviderStateMixin {
  double teamWidth = 45;

  @override
  void initState() {
    Provider.of<MatchDetailController>(context, listen: false)
        .isLoadingScoreCard = true;
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Map<String, String> matchData = {"match_id": widget.matchId.toString()};
      Provider.of<MatchDetailController>(context, listen: false)
          .getScorecardData(context, matchData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child: mContainer(
            context: context,
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                selectInning()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget selectInning() {
    double mWidth = MediaQuery.of(context).size.width;
    double widgetHeight = MediaQuery.of(context).size.height;
    double mHeight = 40;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    MatchDetailController provider = Provider.of(context, listen: false);
    Map firstTeamData = {};
    Map secondTeamData = {};
    List batsman = [];
    List bolwer = [];
    List fallwicket = [];
    List partnership = [];
    if (provider.scorecardTeam1Data.containsKey("team")) {
      firstTeamData = provider.scorecardTeam1Data["team"];
    }
    if (provider.scorecardTeam2Data.containsKey("team")) {
      secondTeamData = provider.scorecardTeam2Data["team"];
    }

    if (provider.scorecardData.containsKey("batsman")) {
      batsman = provider.scorecardData["batsman"];
    }

    if (provider.scorecardData.containsKey("bolwer")) {
      bolwer = provider.scorecardData["bolwer"];
    }

    if (provider.scorecardData.containsKey("fallwicket")) {
      fallwicket = provider.scorecardData["fallwicket"];
    }

    if (provider.scorecardData.containsKey("partnership")) {
      partnership = provider.scorecardData["partnership"];
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (firstTeamData.isNotEmpty)
              InkWell(
                onTap: () {
                  provider.switchScorecard(1);
                },
                child: Container(
                  width: mWidth / 2 - 20,
                  height: mHeight,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                      border: Border.all(
                          color: provider.selectedSTeam == 2
                              ? Theme.of(context).hintColor.withOpacity(0.3)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5),
                      color: provider.selectedSTeam == 1
                          ? const Color(0XFF00619c)
                          : Colors.transparent),
                  child: Center(
                    child: Text(
                      "${firstTeamData["short_name"]} ${firstTeamData["score"].toString()}-${firstTeamData["wicket"].toString()}(${firstTeamData["over"]})",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: "b",
                          fontSize: 15,
                          color: provider.selectedSTeam == 1
                              ? Colors.white
                              : (isDarkTheme ? Colors.white : Colors.black)),
                    ),
                  ),
                ),
              ),
            if (secondTeamData.isNotEmpty)
              const SizedBox(
                width: 10,
              ),
            if (secondTeamData.isNotEmpty)
              InkWell(
                onTap: () {
                  provider.switchScorecard(2);
                },
                child: Container(
                  width: mWidth / 2 - 20,
                  height: mHeight,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                      border: Border.all(
                          color: provider.selectedSTeam == 1
                              ? Theme.of(context).hintColor.withOpacity(0.3)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5),
                      color: provider.selectedSTeam == 2
                          ? const Color(0XFF00619c)
                          : Colors.transparent),
                  child: Center(
                    child: Text(
                      "${secondTeamData["short_name"]} ${secondTeamData["score"].toString()}-${secondTeamData["wicket"].toString()}(${secondTeamData["over"]})",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: "b",
                          fontSize: 15,
                          color: provider.selectedSTeam == 2
                              ? Colors.white
                              : (isDarkTheme ? Colors.white : Colors.black)),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if(provider.selectedSTeam == 1 && firstTeamData.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Score",
                style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor, fontSize: 18),),
              Text("${firstTeamData["score"].toString()}-${firstTeamData["wicket"].toString()}(${firstTeamData["over"]})",
                style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor, fontSize: 18),),
            ],
          ),
        ),
        if(provider.selectedSTeam == 2 && secondTeamData.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Score",
                style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor, fontSize: 18),),
              Text("${secondTeamData["score"].toString()}-${secondTeamData["wicket"].toString()}(${secondTeamData["over"]})",
                style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor, fontSize: 18),),
            ],
          ),
        ),
        provider.isLoadingScoreCard
            ? SizedBox(
                height: widgetHeight / 1.5,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : provider.scorecardData.isEmpty
                ? SizedBox(
                    height: widgetHeight / 1.5,
                    child: Center(child: emptyWidget(context)))
                : Container(
                    child: provider.scorecardData["batsman"].isEmpty
                        ? Center(child: emptyWidget(context))
                        : Column(
                            children: [
                              if (batsman.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(40),
                                          blurRadius: 2.0,
                                          offset: Offset(0.0, 0.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context).colorScheme.primaryContainer),
                                  child: Column(
                                    children: [
                                      summeryRowHeader(
                                          "Batter", "R", "B", "4s", "6s", "SR"),
                                      hrLightWidget(context),
                                      ...batsman.map((e) {
                                        return Column(children: [
                                          summeryRow(
                                              e,
                                              e["run"].toString() ?? "",
                                              e["ball"].toString() ?? "",
                                              e["fours"].toString() ?? "",
                                              e["sixes"].toString() ?? "",
                                              e["strike_rate"].toString() ??
                                                  ""),
                                          hrLightWidget(context),
                                        ]);
                                      })
                                    ],
                                  ),
                                ),
                              if (bolwer.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Column(
                                    children: [
                                      summeryRowHeader(
                                          "Bowler", "0", "M", "R", "W", "ER"),
                                      hrLightWidget(context),
                                      ...bolwer.map((e) {
                                        return Column(children: [
                                          bowlerRow(
                                              e["name"],
                                              e["over"].toString() ?? "",
                                              e["maiden"].toString() ?? "",
                                              e["run"].toString() ?? "",
                                              e["wicket"].toString() ?? "",
                                              e["economy"].toString() ?? ""),
                                          hrLightWidget(context),
                                        ]);
                                      })
                                    ],
                                  ),
                                ),
                              if (fallwicket.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Column(
                                    children: [
                                      fallPartnerRowHeader(
                                          "Fall of wickets", "Score", "Over"),
                                      hrLightWidget(context),
                                      ...fallwicket.map((e) {
                                        return Column(children: [
                                          fallPartnerRow(
                                              e["player"],
                                              "${e["score"].toString()}-${e["wicket"].toString()}" ??
                                                  "",
                                              e["over"].toString() ?? ""),
                                          hrLightWidget(context),
                                        ]);
                                      })
                                    ],
                                  ),
                                ),
                              if (partnership.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Column(
                                    children: [
                                      fallPartnerRowHeader(
                                          "Partnership", "Run", "Ball"),
                                      hrLightWidget(context),
                                      ...partnership.map((e) {
                                        return Column(children: [
                                          fallPartnerRow(
                                              e["players_name"],
                                              e["run"].toString() ?? "",
                                              e["ball"].toString() ?? ""),
                                          hrLightWidget(context),
                                        ]);
                                      })
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  )
      ],
    );
  }

  Widget summeryRowHeader(String title, String run, String ball, String four,
      String six, String sr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              run,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ball,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              four,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              six,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              sr,
              style: mTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget summeryRow(
      Map title, String run, String ball, String four, String six, String sr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title["name"],
                  style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor),
                ),
                Text(
                  title["out_by"],
                  style: mItemTextStyle(context)?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              run,
              style: mTextStyle(context)?.copyWith(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ball,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              four,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              six,
              style: mTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sr,
              style: mTextStyle(context),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget bowlerRow(String title, String run, String ball, String four,
      String six, String sr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: mTextStyle(context)?.copyWith(color: Theme.of(context).indicatorColor),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              run,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ball,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              four,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              six,
              style: mTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sr,
              style: mTextStyle(context),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget fallPartnerRowHeader(String title, String run, String ball) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              run,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              ball,
              style: mTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget fallPartnerRow(String title, String run, String ball) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: mTextStyle(context)
                      ?.copyWith(color: Theme.of(context).indicatorColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              run,
              style: mTextStyle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              ball,
              style: mTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
