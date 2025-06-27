
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../../utils/styleUtil.dart';

class OverViewScreen extends StatefulWidget{
  const OverViewScreen({super.key});
  @override
  State<StatefulWidget> createState() => OverViewScreenState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class OverViewScreenState extends State<OverViewScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SeriesController>(builder: (context, listData, _){
      return Scaffold(
        body: SafeArea(
          child: mContainer(
            context: context,
            child: ListView(
              children: [
                addBody(),
              ],
            ),
          ),
        ),
      );
    });
  }
  
  Widget addBody(){
    double teamWidth = 20;
    SeriesController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        mView("Series", provider.selectedSeriesData["series"] ?? ""),
        mView("Duration", provider.selectedSeriesData["series_date"] ?? ""),
        mView("Total matches", provider.selectedSeriesData["total_matches"].toString() ?? ""),
      ],
    );
  }

  Widget mView(String title, String value){
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          mBoxShadow(context)
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontFamily: "m"),),
          Text(value ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12, fontFamily: "m"),),
        ],
      ),
    );
  }
}
