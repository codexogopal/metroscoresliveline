
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/common_color.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class LiveMatchScreen extends StatefulWidget{
  final String matchId;
  final String matchStatus;
  const LiveMatchScreen({super.key, required this.matchId, required this.matchStatus});
  @override
  State<StatefulWidget> createState() => LiveMatchScreenState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LiveMatchScreenState extends State<LiveMatchScreen>{
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    LiveMatchController provider = Provider.of(context, listen: false);
    super.initState();
    if((widget.matchStatus != "1" && widget.matchStatus != "Upcoming")){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      });
    }
    if((widget.matchStatus == "3" || widget.matchStatus == "Finished")){
     provider.getLiveData(context, widget.matchId);
    }

  }

  @override
  Widget build(BuildContext context) {
    LiveMatchController provider = Provider.of(context, listen: false);
    return Consumer<LiveMatchController>(builder: (context, myData, _){
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: mContainer(
              context: context,
              child: (widget.matchStatus != "1" && widget.matchStatus != "Upcoming") ? addBody() :
              emptyWidget(context),
            ),
          ),
        ),
      );
    });
  }

  Widget addBody(){
    double teamImgWidth = 35;
    List last4overs = [];
    LiveMatchController provider = Provider.of(context, listen: false);
    String currentInning = provider.liveMatchData["current_inning"].toString();

    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    String battingTeamId = provider.liveMatchData["batting_team"] ?? "";
    String teamAId = provider.liveMatchData["team_a_id"].toString() ?? "";
    if(provider.liveMatchData.containsKey("last4overs")){
      last4overs = provider.liveMatchData["last4overs"];
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          if(last4overs.isNotEmpty)
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Row(
                children: [
                  ...last4overs.asMap().entries.map((entry){
                    final index = entry.key;
                    final data = entry.value;
                    List balls = data["balls"];
                    return Row(
                      children: [
                        Text("Over ${data["over"].toString()}" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                        ...balls.asMap().entries.map((entryChild){
                          final index = entryChild.key;
                          final ball = entryChild.value.toString();
                          return Row(
                            children: [
                              const SizedBox(width: 5,),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ball == "6" ? Colors.green :
                                      ball == "W" ? Colors.red :
                                      ball == "4" ? Colors.orange.shade900 : Theme.of(context).colorScheme.primaryContainer,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(40),
                                      blurRadius: 2.0,
                                      offset: Offset(0.0, 0.0),
                                    ),
                                  ],
                                ),
                                  child: Center(child: Text(ball.toString() ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),))
                              ),
                            ],
                          );
                        }),
                        const SizedBox(width: 8,),
                        Text("= ${data["runs"].toString()}" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                        const SizedBox(width: 8,),
                        Container(
                          width: 1,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(width: 8,),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          if(provider.liveMatchData.containsKey("run_need"))
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentInning == "1" ? "" : "Run Needed: ${provider.liveMatchData["run_need"]}" ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                Text(currentInning == "1" ? "" : "Ball Rem: ${provider.liveMatchData["ball_rem"].toString()}" ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
              ],
            ),
          ),
          Padding(
            padding:  const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                provider.liveMatchData["match_type"] == "Test" ?
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(provider.liveMatchData["team_a_short"].toString()?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                          Text(provider.liveMatchData["team_b_short"].toString()?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                          Text("The Draw",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      hrLightWidget(context),
                      const SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(provider.liveMatchData.containsKey("min_rate"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.shade50.withOpacity(0.5)
                            ),
                            child: Text(provider.liveMatchData["min_rate"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                          ),
                          if(provider.liveMatchData.containsKey("max_rate"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: myprimarycolor.shade50
                            ),
                            child: Text(provider.liveMatchData["max_rate"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                          ),
                          if(provider.liveMatchData.containsKey("min_rate_1"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.shade50.withOpacity(0.5)
                            ),
                            child: Text(provider.liveMatchData["min_rate_1"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                          ),

                          if(provider.liveMatchData.containsKey("max_rate_1"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: myprimarycolor.shade50
                            ),
                            child: Text(provider.liveMatchData["max_rate_1"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                          ),
                          if(provider.liveMatchData.containsKey("min_rate_2"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.shade50.withOpacity(0.5)
                            ),
                            child: Text(provider.liveMatchData["min_rate_2"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                          ),
                          if(provider.liveMatchData.containsKey("max_rate_2"))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: myprimarycolor.shade50
                            ),
                            child: Text(provider.liveMatchData["max_rate_2"].toString()?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
          : provider.liveMatchData["fav_team"] == "-" ? SizedBox.shrink() :
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? 0XFF314e78 : CommonColor.fav1BColor),
                            ),
                              child:
                              Text(currentInning == "1" ? provider.liveMatchData["fav_team"] : provider.liveMatchData["fav_team"] ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),)),
                          const SizedBox(width: 10,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav1BColor : CommonColor.fav1BColor),
                            ),
                              child:
                              Text(currentInning == "1" ? provider.liveMatchData["min_rate"].toString() : provider.liveMatchData["min_rate"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav1Color)),)),
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav2BColor : CommonColor.fav2BColor),
                            ),
                              child:
                              Text(currentInning == "1" ? provider.liveMatchData["max_rate"].toString() : provider.liveMatchData["max_rate"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav2Color)),)),
                        ],
                      ),
                    ],
                  ),
                ),
                if(provider.liveMatchData.containsKey("s_min"))
                if(int.parse(provider.liveMatchData["s_min"]) > 0 || int.parse(provider.liveMatchData["s_min"]) > 0)
                const SizedBox(height: 5,),
                if(provider.liveMatchData.containsKey("s_min"))
                if(int.parse(provider.liveMatchData["s_min"]) > 0 || int.parse(provider.liveMatchData["s_min"]) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${provider.liveMatchData["s_ovr"]} Over" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
                      Row(
                        children: [
                          Text("Session:" ?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12, fontFamily: "os", color: Theme.of(context).hintColor),),
                          const SizedBox(width: 10,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav1BColor : CommonColor.fav1BColor),
                            ),
                              child:
                              Text(provider.liveMatchData["s_min"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav1Color)),)),
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav2BColor : CommonColor.fav2BColor),
                            ),
                              child:
                              Text(provider.liveMatchData["s_max"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav2Color)),)),
                        ],
                      ),
                    ],
                  ),
                ),
                if(provider.liveMatchData.containsKey("lambi_ovr"))
                const SizedBox(height: 5,),
                if(provider.liveMatchData.containsKey("lambi_ovr"))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${provider.liveMatchData["lambi_ovr"]} Over" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
                      Row(
                        children: [
                          Text("Lambi:" ?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12, fontFamily: "os", color: Theme.of(context).hintColor),),
                          const SizedBox(width: 10,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav1BColor : CommonColor.fav1BColor),
                            ),
                              child:
                              Text(provider.liveMatchData["lambi_min"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav1Color)),)),
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav2BColor : CommonColor.fav2BColor),
                            ),
                              child:
                              Text(provider.liveMatchData["lambi_max"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav2Color)),)),
                        ],
                      ),
                    ],
                  ),
                ),
                if(provider.liveMatchData["s_run"].toString() != "null" && provider.liveMatchData["s_ball"].toString() != "null")
                const SizedBox(height: 5,),
                if(provider.liveMatchData["s_run"].toString() != "null" && provider.liveMatchData["s_ball"].toString() != "null")
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
                      Row(
                        children: [
                          Text("Run X Ball:" ?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12, fontFamily: "os", color: Theme.of(context).hintColor),),
                          const SizedBox(width: 10,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav1BColor : CommonColor.fav1BColor),
                            ),
                              child:
                              Text(provider.liveMatchData["s_run"].toString() == "null" ? "" : provider.liveMatchData["s_run"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav1Color)),)),
                          const SizedBox(width: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(isDarkTheme ? CommonColor.darkFav2BColor : CommonColor.fav2BColor),
                            ),
                              child:
                              Text( provider.liveMatchData["s_ball"].toString() == "null" ? "" : provider.liveMatchData["s_ball"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav2Color)),)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                if(provider.liveMatchData["batsman"] != null)
                battersWidget(),
                const SizedBox(height: 10,),
                yetToBet(),
                const SizedBox(height: 10,),
                bowlerWidget(),
                const SizedBox(height: 10,),
                if(provider.liveMatchData.containsKey("session") && provider.liveMatchData["session"] != null)
                showSession(),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget yetToBet(){
    LiveMatchController provider = Provider.of(context, listen: false);
    List yetToBet = provider.liveMatchData["yet_to_bet"] == null ? [] : provider.liveMatchData["yet_to_bet"];
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Yet To Bet", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
          const SizedBox(height: 5,),
          Wrap(
            spacing: 5.0,
            runSpacing: 3.0,
            children: yetToBet.map((itemName) {
              return Text("$itemName,", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11,letterSpacing: 1),);
            }).toList(),
          ),
        ],
      ),
    );
  }


  Widget battersWidget(){
    LiveMatchController provider = Provider.of(context, listen: false);
    double teamWidth = 20;
    List batsman = [];
    Map firstBatsMan = {};
    Map secondBatsMan = {};
    if(provider.liveMatchData["batsman"] != null){
      batsman = provider.liveMatchData["batsman"];
      firstBatsMan = batsman[0];
      secondBatsMan = batsman[1];
    }else{
      batsman = [];
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summeryRowHeader("Batter", "R(B)", "4s", "6s", "SR"),
          hrLightWidget(context),
          summeryRow(firstBatsMan["name"], "${firstBatsMan["run"]}(${firstBatsMan["ball"]})".toString(),
              firstBatsMan["fours"].toString(), firstBatsMan["sixes"].toString(), firstBatsMan["strike_rate"].toString()),
          hrLightWidget(context),
          summeryRow(secondBatsMan["name"], "${secondBatsMan["run"]}(${secondBatsMan["ball"]})".toString(), secondBatsMan["fours"].toString(),
              secondBatsMan["sixes"].toString(), secondBatsMan["strike_rate"].toString()),
          hrLightWidget(context),
          if(provider.liveMatchData.containsKey("partnership"))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Partnership: " ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13),),
                    Text("${provider.liveMatchData["partnership"]["run"]}(${provider.liveMatchData["partnership"]["ball"]})" ?? "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13, color: Theme.of(context).hintColor),),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Last wkt: " ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13),),
                    if(provider.liveMatchData.containsKey("lastwicket"))
                    Text("${provider.liveMatchData["lastwicket"]["player"]} ${provider.liveMatchData["lastwicket"]["run"]}(${provider.liveMatchData["lastwicket"]["ball"]})" ?? "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13, color: Theme.of(context).hintColor),),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget showSession(){
    LiveMatchController provider = Provider.of(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Text("Session" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
          const SizedBox(height: 10,),
          hrLightWidget(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: HtmlWidget(provider.liveMatchData["session"],textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }

  Widget summeryRowHeader(String title, String odi, String t20, String test, String ipl){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              ipl,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget summeryRow(String title, String odi, String t20, String test, String ipl){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ipl,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget bowlerWidget(){
    LiveMatchController provider = Provider.of(context, listen: false);
    double teamWidth = 20;
    Map currentBowler = {};
    Map lastBowler = {};
    if(provider.liveMatchData.containsKey("bolwer")){
      currentBowler = provider.liveMatchData["bolwer"];
    }
    if(provider.liveMatchData.containsKey("last_bolwer")){
      lastBowler = provider.liveMatchData["last_bolwer"];
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bowlerRowHeader("Bowler", "W-R", "Over", "Econ"),
          hrLightWidget(context),
          if(provider.liveMatchData.containsKey("bolwer"))
          bowlerRow(currentBowler["name"], "${currentBowler["wicket"]}-${currentBowler["run"]}".toString(),
              currentBowler["over"].toString(), currentBowler["economy"].toString()),
          hrLightWidget(context),
          if(provider.liveMatchData.containsKey("last_bolwer"))
          bowlerRow(lastBowler["name"], "${lastBowler["wicket"]}-${lastBowler["run"]}".toString(), lastBowler["over"].toString(),
              lastBowler["economy"].toString()),
          hrLightWidget(context),
        ],
      ),
    );
  }

  Widget bowlerRowHeader(String title, String odi, String t20, String test){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "os", fontSize: 11, color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget bowlerRow(String title, String odi, String t20, String test){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}