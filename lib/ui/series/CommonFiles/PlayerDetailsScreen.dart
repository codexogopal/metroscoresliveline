
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class PlayerDetailsScreen extends StatefulWidget{
  final Map playerData;
  final bool isHeaderShow;
  const PlayerDetailsScreen({super.key, required this.playerData, required this.isHeaderShow});
  @override
  State<StatefulWidget> createState() => PlayerDetailsScreenState();
}

class PlayerDetailsScreenState extends State<PlayerDetailsScreen>{

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    return Consumer<SeriesController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: widget.isHeaderShow ? AppBars.myAppBar("", context, true) : null,
        body: SafeArea(
          child: mContainer(
            context: context,
            child: Column(
              children: [
                Expanded(child: widget.playerData.isNotEmpty ? addBody() : emptyWidget(context)),
                if(widget.isHeaderShow)
                  instagramFollowAds(context)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget addBody() {
    double myWidth = MediaQuery.of(context).size.width;
    double myHeight = 230;
    SeriesController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Map pData = widget.playerData["player"];
    return ListView(
      children: [
        CachedNetworkImage(
          imageUrl: pData["image"] ??'https://www.com.au/image_url.png',
          imageBuilder: (context, imageProvider) => Container(
            height: myHeight,
            width: myWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logo.png",
              height: myHeight,
              width: myWidth,
              fit: BoxFit.cover,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/logo.png",
            height: myHeight,
            width: myWidth,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                pData["name"] ?? "",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "Personal Information",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: isDarkTheme ? Colors.white70 : myprimarycolor),
              ),
            ),
            detailRow("Born", pData["born"]),
            hrLightWidget(context),
            detailRow("Birth Place", pData["birth_place"]),
            hrLightWidget(context),
            detailRow("Height", pData["height"]),
            hrLightWidget(context),
            detailRow("Role", pData["play_role"]),
            hrLightWidget(context),
            detailRow("Batting Style", pData["style_bating"]),
            hrLightWidget(context),
            detailRow("Bowling Style", pData["style_bowling"]),
            if(widget.playerData.containsKey("teams"))
              careerInfo(),
            if(widget.playerData.containsKey("batting_career"))
              battingSummary(),
            if(widget.playerData.containsKey("bowling_career"))
              bowingSummary(),
            if(pData.containsKey("description") && pData["description"] != null && pData["description"] != "")
              profileWidget(),
            const SizedBox(height: 50,),
          ],
        ),
      ],
    );
  }

  Widget careerInfo(){
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    SeriesController provider = Provider.of(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Career Information",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: isDarkTheme ? Colors.white70 : myprimarycolor),
          ),
        ),
        if(widget.playerData.containsKey("teams"))
          detailRow("Teams", widget.playerData["teams"]),
      ],
    );
  }
  Widget detailRow(String title, String detail){
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      detail,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget battingSummary(){
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    SeriesController provider = Provider.of(context, listen: false);
    List battingSummary = widget.playerData["batting_career"];
    Map odiList = battingSummary[0];
    Map t20List = battingSummary[1];
    Map testList = battingSummary[2];
    Map iplList = battingSummary[3];
    double teamWidth = 20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Batting Career Summary",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: isDarkTheme ? Colors.white70 : myprimarycolor),
          ),
        ),
        summeryRowHeader("", "ODI", "T20", "TEST", "IPL"),
        summeryRow("Matches", odiList["matches"].toString(), t20List["matches"].toString(), testList["matches"].toString(), iplList["matches"].toString()),
        hrLightWidget(context),
        summeryRow("Inning", odiList["inning"].toString(), t20List["inning"].toString(), testList["inning"].toString(), iplList["inning"].toString()),
        hrLightWidget(context),
        summeryRow("Runs", odiList["runs"].toString(), t20List["runs"].toString(), testList["runs"].toString(), iplList["runs"].toString()),
        hrLightWidget(context),
        summeryRow("Balls", odiList["balls"].toString(), t20List["balls"].toString(), testList["balls"].toString(), iplList["balls"].toString()),
        hrLightWidget(context),
        summeryRow("Highest", odiList["high_score"].toString(), t20List["high_score"].toString(), testList["high_score"].toString(), iplList["high_score"].toString()),
        hrLightWidget(context),
        summeryRow("Average", odiList["avg"].toString(), t20List["avg"].toString(), testList["avg"].toString(), iplList["avg"].toString()),
        hrLightWidget(context),
        summeryRow("SR", odiList["sr"].toString(), t20List["sr"].toString(), testList["sr"].toString(), iplList["sr"].toString()),
        hrLightWidget(context),
        summeryRow("Not Out", odiList["not_out"].toString(), t20List["not_out"].toString(), testList["not_out"].toString(), iplList["not_out"].toString()),
        hrLightWidget(context),
        summeryRow("Fours", odiList["fours"].toString(), t20List["fours"].toString(), testList["fours"].toString(), iplList["fours"].toString()),
        hrLightWidget(context),
        summeryRow("Sixes", odiList["sixes"].toString(), t20List["sixes"].toString(), testList["sixes"].toString(), iplList["sixes"].toString()),
        hrLightWidget(context),
        summeryRow("Ducks", odiList["ducks"].toString(), t20List["ducks"].toString(), testList["ducks"].toString(), iplList["ducks"].toString()),
        hrLightWidget(context),
        summeryRow("50s", odiList["fifty"].toString(), t20List["fifty"].toString(), testList["fifty"].toString(), iplList["fifty"].toString()),
        hrLightWidget(context),
        summeryRow("100s", odiList["hundreds"].toString(), t20List["hundreds"].toString(), testList["hundreds"].toString(), iplList["hundreds"].toString()),
        hrLightWidget(context),
        summeryRow("200s", odiList["two_hundreds"].toString(), t20List["two_hundreds"].toString(), testList["two_hundreds"].toString(), iplList["two_hundreds"].toString()),
        hrLightWidget(context),
        summeryRow("300s", odiList["three_hundreds"].toString(), t20List["three_hundreds"].toString(), testList["three_hundreds"].toString(), iplList["three_hundreds"].toString()),
        hrLightWidget(context),
        summeryRow("400s", odiList["four_hundreds"].toString(), t20List["four_hundreds"].toString(), testList["four_hundreds"].toString(), iplList["four_hundreds"].toString()),

      ],
    );
  }
  Widget summeryRow(String title, String odi, String t20, String test, String ipl){
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              ipl,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  Widget summeryRowHeader(String title, String odi, String t20, String test, String ipl){
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              odi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              t20,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              test,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              ipl,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget bowingSummary(){
    SeriesController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    List battingSummary = widget.playerData["bowling_career"];
    Map odiList = battingSummary[0];
    Map t20List = battingSummary[1];
    Map testList = battingSummary[2];
    Map iplList = battingSummary[3];
    double teamWidth = 20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Bowling Career Summary",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: isDarkTheme ? Colors.white70 : myprimarycolor),
          ),
        ),
        summeryRowHeader("", "ODI", "T20", "TEST", "IPL"),
        summeryRow("Matches", odiList["matches"].toString(), t20List["matches"].toString(), testList["matches"].toString(), iplList["matches"].toString()),
        hrLightWidget(context),
        summeryRow("Inning", odiList["inning"].toString(), t20List["inning"].toString(), testList["inning"].toString(), iplList["inning"].toString()),
        hrLightWidget(context),
        summeryRow("Balls", odiList["balls"].toString(), t20List["balls"].toString(), testList["balls"].toString(), iplList["balls"].toString()),
        hrLightWidget(context),
        summeryRow("Runs", odiList["runs"].toString(), t20List["runs"].toString(), testList["runs"].toString(), iplList["runs"].toString()),
        hrLightWidget(context),
        summeryRow("Wickets", odiList["wkts"].toString(), t20List["wkts"].toString(), testList["wkts"].toString(), iplList["wkts"].toString()),
        hrLightWidget(context),
        summeryRow("Average", odiList["avg"].toString(), t20List["avg"].toString(), testList["avg"].toString(), iplList["avg"].toString()),
        hrLightWidget(context),
        summeryRow("Economy", odiList["economy"].toString(), t20List["economy"].toString(), testList["economy"].toString(), iplList["economy"].toString()),
        hrLightWidget(context),
        summeryRow("SR", odiList["sr"].toString(), t20List["sr"].toString(), testList["sr"].toString(), iplList["sr"].toString()),
        hrLightWidget(context),
        summeryRow("BBI", odiList["bbi"].toString(), t20List["bbi"].toString(), testList["bbi"].toString(), iplList["bbi"].toString()),
        hrLightWidget(context),
        summeryRow("4w", odiList["four_wkt"].toString(), t20List["four_wkt"].toString(), testList["four_wkt"].toString(), iplList["four_wkt"].toString()),
        hrLightWidget(context),
        summeryRow("5w", odiList["five_wkt"].toString(), t20List["five_wkt"].toString(), testList["five_wkt"].toString(), iplList["five_wkt"].toString()),
        hrLightWidget(context),
        summeryRow("10w", odiList["ten_wkt"].toString(), t20List["ten_wkt"].toString(), testList["ten_wkt"].toString(), iplList["ten_wkt"].toString()),
      ],
    );
  }

  Widget profileWidget(){
    SeriesController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Map pData = widget.playerData["player"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Profile",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: isDarkTheme ? Colors.white70 : myprimarycolor),
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: HtmlWidget(pData["description"].toString(),textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold,height: 1.5),),
          ),
        ),
      ],
    );
  }
}
