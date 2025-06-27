
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../session/SessionManager.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/common_color.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';
import '../../match_detail/MatchDetailsScreen.dart';

class MatchPrediction extends StatefulWidget{
  final String matchId;
  final String matchStatus;
  final String predictionType;
  const MatchPrediction({super.key, required this.matchId, required this.matchStatus, required this.predictionType});
  @override
  State<StatefulWidget> createState() => MatchPredictionState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MatchPredictionState extends State<MatchPrediction>{

  @override
  void initState() {
    Provider.of<MatchDetailController>(context, listen: false).isAnyPlanAvailable = false;
    if(SessionManager.isLogin()!){
      Provider.of<MatchDetailController>(context, listen: false).isLoadingPrediction = true;
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
       /* Map<String, String> matchData = {
          "user_id" : SessionManager.getUserId().toString(),
          "match_api_id" : widget.matchInfo["match_id"].toString(),
          "series_api_id" : widget.matchInfo["series_id"].toString(),
          "match_status" : widget.matchInfo["match_status"].toString(),
        };*/
        Provider.of<MatchDetailController>(context, listen: false).checkPrediction(context);
        if(widget.matchStatus != "2"){
          Provider.of<LiveMatchController>(context, listen: false).getLiveData(context, widget.matchId);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _){
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: provider.isLoadingPrediction ? const Center(child: CircularProgressIndicator(),) :
              (provider.isAnyPlanAvailable && widget.predictionType == "m") ? liveData() :
              (provider.isAnyPlanAvailable && widget.predictionType == "f") ? fantasyPrediction() :
              ifUserNotLoginOrRegister(),
          // child: addBody(),
        ),
      );
    });
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

  Widget liveData() {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: ListView(
        children: [
          Consumer<LiveMatchController>(builder: (context, myData, _) {
            return mainData();
          }),
          if(provider.matchPredictionData["toss"] != "" && provider.matchPredictionData["toss"] != null)
          predictionData(provider.matchPredictionData["toss"], "Toss", CommonColor.preGradient01, CommonColor.preGradient02),

          if(provider.matchPredictionData["session"] != "" && provider.matchPredictionData["session"] != null)
          predictionData(provider.matchPredictionData["session"], "Session", CommonColor.preGradient11, CommonColor.preGradient12),

          if(provider.matchPredictionData["match_report"] != "" && provider.matchPredictionData["match_report"] != null)
          predictionData(provider.matchPredictionData["match_report"], "Match Report", CommonColor.preGradient21, CommonColor.preGradient22),

          if(provider.matchPredictionData["book_set"] != "" && provider.matchPredictionData["book_set"] != null)
          predictionData(provider.matchPredictionData["book_set"], "Book Set", CommonColor.preGradient31, CommonColor.preGradient32),

          if(provider.matchPredictionData["jackpot_call"] != "" && provider.matchPredictionData["jackpot_call"] != null)
          predictionData(provider.matchPredictionData["jackpot_call"], "Jackpot Call", CommonColor.preGradient41, CommonColor.preGradient42),
        ],
      ),
    );
  }

  Widget mainData(){
    List last4overs = [];
    LiveMatchController liveProvider = Provider.of(context, listen: false);
    String currentInning = liveProvider.liveMatchData["current_inning"].toString();

    String battingTeamId = liveProvider.liveMatchData["batting_team"] ?? "";
    String teamAId = liveProvider.liveMatchData["team_a_id"].toString() ?? "";
    if(liveProvider.liveMatchData.containsKey("last4overs")){
      last4overs = liveProvider.liveMatchData["last4overs"];
    }
    return Column(
      children: [
        liveProvider.liveMatchData["match_type"] == "Test" ?
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(liveProvider.liveMatchData["team_a_short"].toString()?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                  Text(liveProvider.liveMatchData["team_b_short"].toString()?? "",
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
                  if(liveProvider.liveMatchData.containsKey("min_rate"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade50.withOpacity(0.5)
                      ),
                      child: Text(liveProvider.liveMatchData["min_rate"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                    ),
                  if(liveProvider.liveMatchData.containsKey("max_rate"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: myprimarycolor.shade50
                      ),
                      child: Text(liveProvider.liveMatchData["max_rate"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                    ),
                  if(liveProvider.liveMatchData.containsKey("min_rate_1"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade50.withOpacity(0.5)
                      ),
                      child: Text(liveProvider.liveMatchData["min_rate_1"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                    ),
    
                  if(liveProvider.liveMatchData.containsKey("max_rate_1"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: myprimarycolor.shade50
                      ),
                      child: Text(liveProvider.liveMatchData["max_rate_1"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                    ),
                  if(liveProvider.liveMatchData.containsKey("min_rate_2"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade50.withOpacity(0.5)
                      ),
                      child: Text(liveProvider.liveMatchData["min_rate_2"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),),
                    ),
                  if(liveProvider.liveMatchData.containsKey("max_rate_2"))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: myprimarycolor.shade50
                      ),
                      child: Text(liveProvider.liveMatchData["max_rate_2"].toString()?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black),),
                    ),
                ],
              ),
            ],
          ),
        )
            :
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isPlayingTeamA(battingTeamId, teamAId)
                  ? liveProvider.liveMatchData["team_a"]
                  : liveProvider.liveMatchData["team_b"] ??
                  "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),),
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade50.withOpacity(0.5)
                      ),
                      child:
                      Text(currentInning == "1" ? liveProvider.liveMatchData["fav_team"] : liveProvider.liveMatchData["fav_team"] ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),)),
                  const SizedBox(width: 10,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade50.withOpacity(0.5)
                      ),
                      child:
                      Text(currentInning == "1" ? liveProvider.liveMatchData["min_rate"].toString() : liveProvider.liveMatchData["min_rate"].toString() ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),)),
                  const SizedBox(width: 5,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: myprimarycolor.shade50
                      ),
                      child:
                      Text(currentInning == "1" ? liveProvider.liveMatchData["max_rate"].toString() : liveProvider.liveMatchData["max_rate"].toString() ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12, color: Colors.black),)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget predictionData(String preData, String title, int color1, int color2){
    return Column(
      children: [
        const SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.shade700, width: 1.5,),
              color: Theme.of(context).colorScheme.primaryContainer
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Center(
                child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: "sb",
                    fontSize: 18),),
              ),
              const SizedBox(height: 15,),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(color1), Color(color2)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width-90,
                          // child: HtmlWidget(preData, textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),)),
                        child: HtmlWidget(
                          preData,
                          customStylesBuilder: (element) {
                            if (element.localName == 'p') {
                              return {'display': 'flex', 'align-items': 'center'};
                            }
                            return null;
                          },
                          customWidgetBuilder: (element) {
                            if (element.localName == 'p') {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Icon(Icons.send, color: Theme.of(context).hintColor,size: 20,), // Bullet icon
                                  const SizedBox(width: 10), // Space between bullet and text
                                  Expanded(child: HtmlWidget(element.innerHtml, textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),)),
                                ],
                              );
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fantasyPrediction(){
    MatchDetailController provider = Provider.of(context, listen: false);
    double teamWidth = MediaQuery.of(context).size.width;
    double teamHeight = MediaQuery.of(context).size.height;
    return (provider.matchPredictionData["fantasy_img"] != "" && provider.matchPredictionData["fantasy_img"] != null) ? InkWell(
      onTap: (){
        openWhatsApp(provider.matchPredictionData["fantasy_url"]);
      },
      child: SizedBox(
        width: teamWidth,
        height: teamHeight,
        child: CachedNetworkImage(
          imageUrl: provider.matchPredictionData["fantasy_img"] ??'https://www.google.com.au/image_url.png',
          imageBuilder: (context, imageProvider) => Container(
            height: teamHeight,
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
              height: teamHeight,
              width: teamWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/logo.png",
            height: teamHeight,
            width: teamWidth,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ) :
    emptyWidget(context);
  }
}