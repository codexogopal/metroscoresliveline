import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class Commentary extends StatefulWidget {
  final String matchId;

  const Commentary({super.key, required this.matchId});

  @override
  State<StatefulWidget> createState() => CommentaryState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class CommentaryState extends State<Commentary> with SingleTickerProviderStateMixin {
  double teamWidth = 45;

  @override
  void initState() {
    Provider.of<MatchDetailController>(context, listen: false).isLoadingCommentary = true;
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Map<String, String> matchData = {
        "match_id" : widget.matchId.toString()
      };
      Provider.of<MatchDetailController>(context, listen: false).getCommentary(context, matchData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child: provider.isLoadingCommentary ? const Center(child: CircularProgressIndicator(),) :  mContainer(
            context: context,
            child: SizedBox(
              child: provider.commentaryData.isEmpty ? Center(child: emptyWidget(context)) : ListView(
                children: [
                  const SizedBox(height: 15,),
                  selectInning()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }


  Widget selectInning() {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = 40;
    double borderR = 5;
    MatchDetailController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        provider.commentaryData.isEmpty ? Center(child: emptyWidget(context)) : Column(
          children: [
            ...provider.commentaryData.asMap().entries.map((entry){
              final index = entry.key;
              final pData = entry.value;
              print(pData.toString());
              Map overData = pData["data"];
              return Column(
                  children: [
                    if(pData["type"] == 2)
                     Container(
                       width: mWidth,
                       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                         border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.15))
                       ),
                       child: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Over ${overData["over"]}", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                     fontWeight: FontWeight.w800,
                                     fontFamily: "sb",
                                     fontSize: 14),),
                                 Text("${overData["team"]}: ${overData["team_score"]}-${overData["team_wicket"]}", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                     fontWeight: FontWeight.w800,
                                     fontFamily: "sb",
                                     fontSize: 14),),
                               ],
                             ),
                           ),
                           hrLightWidget(context),
                           Container(
                             color : Theme.of(context).hintColor.withOpacity(0.04),
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(overData["batsman_1_name"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 13),),
                                     Text("${overData["batsman_1_runs"]}(${overData["batsman_1_balls"]})", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 12),),
                                   ],
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(overData["batsman_2_name"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 13),),
                                     Text("${overData["batsman_2_runs"]}(${overData["batsman_2_balls"]})", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 12),),
                                   ],
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(overData["bolwer_name"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 13),),
                                     Text("${overData["bolwer_wickets"]}-${overData["bolwer_runs"]}(${overData["bolwer_overs"]}.0)", style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                         fontWeight: FontWeight.w800,
                                         fontSize: 12),),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                    if(pData["type"] == 2)
                      const SizedBox(height: 10,),
                    if(pData["type"] == 1)
                    Container(
                      width: mWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(overData["overs"] ?? "", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontFamily: "sb",
                                          fontSize: 15),),
                                      const SizedBox(width: 8,),
                                      Text(overData["title"] ?? "", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13),),
                                    ],
                                  ),
                                  const SizedBox(height: 8,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ballResult(overData),
                                      if(overData["description"] != "" && overData["description"].toString() != "null")
                                        const SizedBox(width: 8,),
                                      if(overData["description"] != "" && overData["description"].toString() != "null")
                                        SizedBox(
                                          width: mWidth-100,
                                          child: Text(overData["description"] ?? "", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13),
                                          ),
                                        ),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if(pData["type"] == 1)
                    const SizedBox(height: 10,),
                  ]
              );
            })
          ],
        )
      ],
    );
  }

  Widget ballResult(Map data){
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: data["wicket"] != "" ? Colors.red :
        data["runs"] == "6" ? Colors.green :
        data["runs"] == "4" ? Colors.orange.shade800 : Colors.transparent,
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2), width: 1)
      ),
      child: Center(
        child: Text(
          "${data["wicket"] != "" ? "W" : data["runs"]}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 15),
        ),
      ),
    );
  }
}
