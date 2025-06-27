import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/LiveMatchControllers.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class FancyScreen extends StatefulWidget {
  final String matchId;

  const FancyScreen({super.key, required this.matchId});

  @override
  State<StatefulWidget> createState() => FancyScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class FancyScreenState extends State<FancyScreen> with SingleTickerProviderStateMixin {
  double teamWidth = 45;

  @override
  void initState() {
    Provider.of<MatchDetailController>(context, listen: false).isLoadingFancy = true;
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Map<String, String> matchData = {
        "match_id" : widget.matchId.toString()
      };
      Provider.of<MatchDetailController>(context, listen: false).getFancyData(context, matchData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: provider.isLoadingFancy ? const Center(child: CircularProgressIndicator(),) :  mContainer(
            context: context,
            child: SizedBox(
              child: provider.fancyDataList.isEmpty ? Center(child: emptyWidget(context)) : Column(
                children: [
                  fancyRowHeader("Fancy", "No", "Yes"),
                  hrLightWidget(context),
                  Expanded(child: selectInning())
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
    MatchDetailController provider = Provider.of(context, listen: false);
    return Container(
      child: ListView(
        children: [
          ...provider.fancyDataList.map((e){
            return Column(
              children: [
                fancyItemRow(e["fancy"], e["created"], e["lay_price"], e["lay_size"], e["back_price"], e["lay_size"]),
                hrLightWidget(context)
              ],
            );
          })
        ],
      ),
    );
  }

  Widget fancyRowHeader(String title, String run, String ball){
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
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


  Widget fancyItemRow(String title, String dateTime, String layPrice, String laySize, String backPrice, String backSize){
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
                  style: mTextStyle1(context)?.copyWith(fontSize: 13),
                ),
                Text(
                  dateTime,
                  style: mTextStyle(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  layPrice,
                  style: mTextStyle1(context)?.copyWith(),
                ),
                Text(
                  laySize,
                  style: mTextStyle(context)?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backPrice,
                  style: mTextStyle1(context)?.copyWith(),
                ),
                Text(
                  backSize,
                  style: mTextStyle(context)?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
