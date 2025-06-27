import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/common_color.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class OddsHistory extends StatefulWidget {
  final String matchId;

  const OddsHistory({super.key, required this.matchId});

  @override
  State<StatefulWidget> createState() => OddsHistoryState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class OddsHistoryState extends State<OddsHistory> with SingleTickerProviderStateMixin {
  double teamWidth = 45;

  @override
  void initState() {
    Provider.of<MatchDetailController>(context, listen: false).isLoadingOdds = true;
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Map<String, String> matchData = {
        "match_id" : widget.matchId.toString()
      };
      Provider.of<MatchDetailController>(context, listen: false).getOddsHistory(context, matchData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child: provider.isLoadingOdds ? const Center(child: CircularProgressIndicator(),) :  mContainer(
            context: context,
            child: SizedBox(
              child: provider.oddsDataList.isEmpty ? Center(child: emptyWidget(context)) : ListView(
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
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double mHeight = 40;
    MatchDetailController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                provider.switchOddsData(1);
              },
              child: Container(
                width: mWidth/2-20,
                height: mHeight,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                    border: Border.all(color: provider.selectedInning == 2 ? Theme.of(context).hintColor.withOpacity(0.3) :
                Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                color: provider.selectedInning == 1 ? myprimarycolor : Colors.transparent),
                child: Center(
                  child: Text(
                    "1st Inning",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: "b",
                        fontSize: 15, color: provider.selectedInning == 1 ? Colors.white : (isDarkTheme ? Colors.white : Colors.black)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: (){
                provider.switchOddsData(2);
              },
              child: Container(
                width: mWidth/2-20,
                height: mHeight,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                    border: Border.all(color: provider.selectedInning == 1 ? Theme.of(context).hintColor.withOpacity(0.3) :
                Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                color: provider.selectedInning == 2 ? myprimarycolor : Colors.transparent),
                child: Center(
                  child: Text(
                    "2nd Inning",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: "b",
                        fontSize: 15, color: provider.selectedInning == 2 ? Colors.white : (isDarkTheme ? Colors.white : Colors.black)),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child:  provider.listForShowOddsData.isEmpty ? Center(child: emptyWidget(context)) : Column(
            children: [
              ...provider.listForShowOddsData.map((e){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          // Expanded(flex: 0,child: Text("${e["overs"].toString()}\n${e["time"]}", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,)),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(e["overs"].toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(), textAlign: TextAlign.center,),
                                Container(width: 50,height: 1,decoration: BoxDecoration(
                                  color: Theme.of(context).indicatorColor,
                                ),child: const Text(""),),
                                Text(e["time"].toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(), textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(e["s_min"].toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red, fontSize: 13), textAlign: TextAlign.center,),
                                Container(width: 30,height: 1,decoration: BoxDecoration(
                                  color: Theme.of(context).indicatorColor,
                                ),child: const Text(""),),
                                Text(e["s_max"].toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green, fontSize: 13), textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          Expanded(flex: 1,child: Text(e["fav_team"].toString(), style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,)),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                color: Color(isDarkTheme ? CommonColor.darkFav1BColor : CommonColor.fav1BColor),
                              ),
                              child:
                              Text(e["min_rate"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav1Color)),textAlign: TextAlign.center,)),
                          const SizedBox(width: 5,),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                color: Color(isDarkTheme ? CommonColor.darkFav2BColor : CommonColor.fav2BColor),
                              ),
                              child:
                              Text(e["max_rate"].toString() ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13,
                                    fontFamily: "b",fontWeight: FontWeight.w800,color: Color(isDarkTheme ? CommonColor.darkFavTColor : CommonColor.fav2Color)),textAlign: TextAlign.center)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    hrLightWidget(context),
                    const SizedBox(height: 5,),
                  ]
                );
              })
            ],
          ),
        )
      ],
    );
  }
}
