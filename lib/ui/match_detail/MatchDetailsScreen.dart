import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:metroscoresliveline/ui/match_detail/scorecard/ScorecardScreen.dart';

import '../../Constant.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../controllers/MatchDetailController.dart';
import '../../controllers/SeriesController.dart';
import '../../session/SessionManager.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../commonUi/CommonUi.dart';
import '../home/home/HomeMatch.dart';
import '../home/live/LiveMatchList.dart';
import '../series/tabs/PointsTableScreen.dart';
import 'commentary/Commentary.dart';
import 'fancy/FancyScreen.dart';
import 'info/MatchInfoScreen.dart';
import 'live/LiveMatchScreen.dart';
import 'matchPrediction/MatchPrediction.dart';
import 'oddshistory/OddsHistory.dart';

class MatchDetailsScreen extends StatefulWidget {
  final String matchId;
  int? matchTab;

  MatchDetailsScreen({super.key, required this.matchId, this.matchTab});

  @override
  State<StatefulWidget> createState() => MatchDetailsScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class MatchDetailsScreenState extends State<MatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late LiveMatchController liveMatchController;
  double teamWidth = 45;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this, initialIndex: widget.matchTab == null ? 0 : widget.matchTab!);
    Provider.of<SeriesController>(context, listen: false).havePointsTableReload = true;
    Provider.of<MatchDetailController>(context, listen: false).loadedMatchId = "";
    Provider.of<MatchDetailController>(context, listen: false).teamAData = {};
    Provider.of<MatchDetailController>(context, listen: false).teamAData = {};
    Provider.of<MatchDetailController>(context, listen: false).teamData = {};
    /*if (Provider.of<MatchDetailController>(context, listen: false)
                .matchInfo["match_status"] ==
            "Live" ||
        Provider.of<MatchDetailController>(context, listen: false)
                .matchInfo["match_status"]
                .toString() ==
            "2") {
      // Start fetching match info when the screen is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<LiveMatchController>(context, listen: false)
            .startLiveMatchInfo(context, widget.matchId.toString());
      });
    }*/
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    liveMatchController =
        Provider.of<LiveMatchController>(context, listen: false);
    liveMatchController.isLoadingFirstTime = true;
    if (Provider.of<MatchDetailController>(context, listen: false)
                .matchInfo["match_status"] ==
            "Live" ||
        Provider.of<MatchDetailController>(context, listen: false)
                .matchInfo["match_status"]
                .toString() ==
            "2") {
      // Start fetching match info when the screen is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        liveMatchController.startLiveMatchInfo(
            context, widget.matchId.toString());
      });
    }
  }

  @override
  void dispose() {
    // Stop fetching match info when the screen is disposed
    liveMatchController.stopFetchingMatchInfo();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _) {
      return Scaffold(
        appBar: myStatusBar(),
        body: SafeArea(
          child: SizedBox(
            child: Column(
              children: [
                appbarView(),
                Expanded(child: addBody()),
                instagramFollowAds(context)
              ],
            ),
          ),
        ),
      );
    });
  }

  double myWidth = 50;
  double myHeight = 150;

  Widget appbarView() {
    MatchDetailController provider = Provider.of(context, listen: false);
    return mContainer(
      context: context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "${provider.matchInfo["team_a_short"]} VS ${provider.matchInfo["team_b_short"]}, ${provider.matchInfo["matchs"]}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontFamily: "sb",
                      fontSize: 18),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            // margin: const EdgeInsets.symmetric(horizontal: 5),
            child: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
                labelColor: Theme.of(context).tabBarTheme.labelColor,
                unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                controller: _tabController,
                /*indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),*/
                tabs: const <Widget>[
                  Tab(
                    child: Text(
                      'Info',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Commentary',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                 /* Tab(
                    child: Text(
                      'TV',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),*/
                  Tab(
                    child: Text(
                      'Live',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                  /*Tab(
                    child: Text(
                      'Fantasy Prediction',
                      style: TextStyle(fontSize: 14, fontFamily: "sb", color: Colors.red.shade700, fontWeight: FontWeight.w900),
                    ),
                  ),*/
                  Tab(
                    child: Text(
                      'Scorecard',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Point Table',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Fancy',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Odds History',
                      style: TextStyle(fontSize: 14, fontFamily: "sb"),
                    ),
                  ),
                ],
              ),
          ),
          // hrLightGreyWidget(),
          showMatchDetailBoard(),
        ],
      ),
    );
  }

  Widget showMatchDetailBoard() {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        if (provider.matchInfo["match_status"] == "Live" ||
            provider.matchInfo["match_status"].toString() == "2")
          liveData(),
        if (provider.matchInfo["match_status"] == "Upcoming" ||
            provider.matchInfo["match_status"].toString() == "1")
          upcomingDetailBoard(),
        if (provider.matchInfo["match_status"] == "Finished" ||
            provider.matchInfo["match_status"].toString() == "3")
          finishedDetailBoard()
      ],
    );
  }

  Widget upcomingDetailBoard() {
    MatchDetailController provider = Provider.of(context, listen: false);
    double teamImgWidth = 35;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: teamImgWidth,
                  height: teamImgWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(teamImgWidth / 2),
                      border: Border.all(color: Colors.grey.shade300, width: 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(teamImgWidth / 2),
                    child: CachedNetworkImage(
                      imageUrl: provider.matchInfo["team_a_img"] ??
                          'https://cricketchampion.co.in/webroot/img/teams/139358236_team.png',
                      imageBuilder: (context, imageProvider) => Container(
                        height: teamImgWidth,
                        width: teamImgWidth,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: teamImgWidth,
                          width: teamImgWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/logo.png",
                        height: teamImgWidth,
                        width: teamImgWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  provider.matchInfo["team_a_short"] ?? "hi",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: "b",
                        fontSize: 16,
                      ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Start at:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 13,
                  ),
                ),
                Text(
                  "${provider.matchInfo["match_time"]}," ?? "hi",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18,
                  ),
                ),
                Text(
                  provider.matchInfo["match_date"] ?? "hi",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  provider.matchInfo["team_b_short"] ?? "hi",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: "b",
                        fontSize: 16,
                      ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: teamImgWidth,
                  height: teamImgWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(teamImgWidth / 2),
                      border: Border.all(color: Colors.grey.shade300, width: 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(teamImgWidth / 2),
                    child: CachedNetworkImage(
                      imageUrl: provider.matchInfo["team_b_img"] ??
                          'https://cricketchampion.co.in/webroot/img/teams/139358236_team.png',
                      imageBuilder: (context, imageProvider) => Container(
                        height: teamImgWidth,
                        width: teamImgWidth,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: teamImgWidth,
                          width: teamImgWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/logo.png",
                        height: teamImgWidth,
                        width: teamImgWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget finishedDetailBoard() {
    MatchDetailController provider = Provider.of(context, listen: false);
    double teamWidth = 35;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: teamWidth,
                    height: teamWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(teamWidth / 2),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(teamWidth / 2),
                      child: CachedNetworkImage(
                        imageUrl: provider.matchInfo["team_a_img"] ??
                            'https://cricketchampion.co.in/webroot/img/teams/139358236_team.png',
                        imageBuilder: (context, imageProvider) => Container(
                          height: teamWidth,
                          width: teamWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: teamWidth,
                            width: teamWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/logo.png",
                          height: teamWidth,
                          width: teamWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    provider.matchInfo["team_a_short"] ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: "b",
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/vs1.png",
                height: 18,
              ),
              Row(
                children: [
                  Text(
                    provider.matchInfo["team_b_short"] ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: "b",
                      color: Colors.grey,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: teamWidth,
                    height: teamWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(teamWidth / 2),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(teamWidth / 2),
                      child: CachedNetworkImage(
                        imageUrl: provider.matchInfo["team_b_img"] ??
                            'https://cricketchampion.co.in/webroot/img/teams/139358236_team.png',
                        imageBuilder: (context, imageProvider) => Container(
                          height: teamWidth,
                          width: teamWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: teamWidth,
                            width: teamWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/logo.png",
                          height: teamWidth,
                          width: teamWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        hrLightGreyWidget(),
        Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.matchInfo["result"],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontFamily: "sb"),
                ),
              ],
            )),
        hrLightGreyWidget(),
      ],
    );
  }

  Widget liveData() {
    return Consumer<LiveMatchController>(builder: (context, myData, _) {
      return /*liveMatchController.isLoadingFirstTime ? const Center(child: Text(""),) : */ liveDetailBoard();
    });
  }

  Widget liveDetailBoard() {
    LiveMatchController provider = Provider.of(context, listen: false);
    String battingTeamId = provider.liveMatchData["batting_team"] ?? "";
    String teamAId = provider.liveMatchData["team_a_id"].toString() ?? "";
    List batsman = provider.liveMatchData["batsman"] ?? [];
    String currentInning =
        provider.liveMatchData["current_inning"].toString() ?? "";
    double myWidth = MediaQuery.of(context).size.width;
    return Consumer<LiveMatchController>(builder: (context, myData, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: myWidth / 2.5,
                  height: provider.liveMatchData["match_type"] == "Test" ? 85 : 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: teamWidth,
                            height: teamWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(teamWidth / 2),
                                border: Border.all(color: Colors.grey.shade300, width: 2)),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(teamWidth / 2),
                              child: CachedNetworkImage(
                                imageUrl: isPlayingTeamA(battingTeamId, teamAId)
                                    ? provider.liveMatchData["team_a_img"]
                                    : provider.liveMatchData["team_b_img"] ??
                                        'https://cricketchampion.co.in/webroot/img/teams/13935.png',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: teamWidth,
                                  width: teamWidth,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    height: teamWidth,
                                    width: teamWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/logo.png",
                                  height: teamWidth,
                                  width: teamWidth,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isPlayingTeamA(battingTeamId, teamAId)
                                    ? provider.liveMatchData["team_a_short"]
                                    : provider.liveMatchData["team_b_short"] ??
                                        "",
                                // "RSA-W" ?? "hi",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontFamily: "b",
                                        fontSize: 18,),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/4.8,
                                child: Wrap(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      // provider.liveMatchData["team_a_scores"] ?? "",
                                      // "P${provider.liveMatchData['powerplay'].toString() == "null" ? "" : provider.liveMatchData['powerplay'].toString()}",
                                      isPlayingTeamA(battingTeamId, teamAId)
                                          ? (provider.liveMatchData[
                                                          "team_a_scores"]
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : provider
                                                  .liveMatchData["team_a_scores"]
                                                  .toString())
                                          : (provider.liveMatchData[
                                                              "team_b_scores"]
                                                          .toString() ==
                                                      "null"
                                                  ? ""
                                                  : provider.liveMatchData[
                                                          "team_b_scores"]
                                                      .toString()) ??
                                              "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontFamily: "b",
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                      child: Text(
                                        isPlayingTeamA(battingTeamId, teamAId)
                                            ? provider
                                                .liveMatchData["team_a_over"]
                                            : provider.liveMatchData[
                                                    "team_b_over"] ??
                                                "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      if(provider.liveMatchData["powerplay"] != "")
                      Container(
                          // padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red.shade500,
                          ),
                          child: Center(
                            child: Text(
                              "P${provider.liveMatchData['powerplay'].toString() == "null" ? "" : provider.liveMatchData['powerplay'].toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "sb",
                                      fontSize: 12,),
                            ),
                          ))
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 75,
                      width: myWidth / 2.2,
                      margin: const EdgeInsets.fromLTRB(5, 12, 5, 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      decoration: BoxDecoration(
                          color: const Color(0XFF003e7c),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: provider.liveFirstCircle(context, provider.liveMatchData["first_circle"] ?? ""))

                      /*Center(
                          child: Text(
                        // isPlayingTeamA(battingTeamId, teamAId) ? provider.liveMatchData["first_circle"] : provider.liveMatchData["second_circle"] ?? "",
                        provider.liveMatchData["first_circle"] ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: "sb",
                            fontSize: 14),
                            textAlign: TextAlign.center,
                      )),*/
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: (){
                          provider.isMuteVoice(provider.isVoiceMute ? false : true);
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: myprimarycolor.shade900),
                            child: Icon(
                              provider.isVoiceMute ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                              size: 18,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          hrLightGreyWidget(),
          Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentInning == "1" ? provider.liveMatchData["toss"] : (provider.liveMatchData["match_type"] == "Test"
                    ? provider.liveMatchData["trail_lead"]
                    : provider.liveMatchData["need_run_ball"]
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 12,),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "CRR: ${provider.liveMatchData["curr_rate"].toString() == "null" ? "" : provider.liveMatchData["curr_rate"].toString()}" ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            currentInning == "2"
                                ? "RRR: ${provider.liveMatchData["rr_rate"]}"
                                : "" ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        currentInning == "2"
                            ? "Target: ${provider.liveMatchData["target"]}"
                            : "" ?? "hi",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  )
                ],
              )),
          hrLightGreyWidget(),
        ],
      );
    });
  }

  Widget addBody() {
    MatchDetailController provider = Provider.of(context, listen: false);
    String status = provider.matchListObjectInfo["match_status"] == "Upcoming" ? "1" :
    provider.matchListObjectInfo["match_status"] == "Live" ? "2" :
    provider.matchListObjectInfo["match_status"] == "Finished" ? "3" : provider.matchListObjectInfo["match_status"].toString();
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        MatchInfoScreen(matchId: widget.matchId),
        Commentary(matchId: widget.matchId),
        // ifUserNotLoginOrRegister(),
        // MatchPrediction(matchId: widget.matchId, matchStatus: status, predictionType: "m",),
        LiveMatchScreen(matchId: widget.matchId, matchStatus: provider.matchInfo["match_status"].toString()),
        // MatchPrediction(matchId: widget.matchId, matchStatus: status, predictionType: "f",),
        ScorecardScreen(matchId: widget.matchId),
        PointsTableScreen(seriesId: provider.matchInfo["series_id"].toString()),
        FancyScreen(matchId: widget.matchId),
        OddsHistory(matchId: widget.matchId),
      ],
      // )
      // ,
    );
  }


  Widget ifUserNotLoginOrRegister(){
    return Center(
      child: SessionManager.isLogin()! ? OutlinedButton(
        onPressed: (){
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          side: const BorderSide(width: 2, color: myprimarycolor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
          child: Text(
            "View Plans",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: myprimarycolor, fontFamily: "sb", fontSize: 15),
          ),
        ),
      )  : OutlinedButton(
        onPressed: (){
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          side: const BorderSide(width: 2, color: myprimarycolor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
          child: Text(
            "Register",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: myprimarycolor, fontFamily: "sb", fontSize: 15),
          ),
        ),
      ),
    );
  }

}
