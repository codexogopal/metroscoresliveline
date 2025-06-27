import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metroscoresliveline/ui/series/tabs/FixturesScreen.dart';
import 'package:metroscoresliveline/ui/series/tabs/OverViewScreen.dart';
import 'package:metroscoresliveline/ui/series/tabs/PointsTableScreen.dart';
import 'package:metroscoresliveline/ui/series/tabs/RecentScreen.dart';
import 'package:metroscoresliveline/ui/series/tabs/SquadsScreen.dart';
import 'package:metroscoresliveline/ui/series/tabs/VenuesScreen.dart';

import '../../Constant.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../controllers/SeriesController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/styleUtil.dart';
import '../home/home/HomeMatch.dart';
import '../home/live/LiveMatchList.dart';
import 'CommonFiles/PlayerDetailsScreen.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => SeriesScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];
String seriesId = "";
class SeriesScreenState extends State<SeriesScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<SeriesController>(context, listen: false).getSeriesList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    LiveMatchController liveMatchController = Provider.of(context, listen: false);
    liveMatchController.stopFetchingMatchInfo();
    provider.seriesLoading = false;
    return Consumer<SeriesController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            child: provider.seriesListData.isEmpty ? const Center(
                child: Text("No Data Found")) : Column(
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
    SeriesController provider = Provider.of(context, listen: false);
    seriesId = provider.selectedSeriesData["series_id"].toString();
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          categoryView(),
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            // margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
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
                    'Overview',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Fixtures',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Recent',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Squads',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Points Table',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Venues',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
                Tab(
                  child: Text(
                    'Man of Series',
                    style: TextStyle(fontSize: 14, fontFamily: "sb"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryView() {
    double myHeight = 85;
    double myWidth = 75;
    SeriesController provider = Provider.of(context, listen: false);
    return provider.seriesListData.isEmpty ? const SizedBox(height: 0,) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.selectedSeriesData["series"],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontFamily: "sb", fontSize: 18),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "${provider.selectedSeriesData["series_date"]}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 10, fontFamily: "m"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addBody() {
    SeriesController provider = Provider.of(context, listen: false);
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        const OverViewScreen(),
        const FixturesScreen(),
        const RecentScreen(),
        const SquadsScreen(),
        PointsTableScreen(seriesId : seriesId),
        const VenuesScreen(),
        // const Center(child: Text("Man of Series"),),
        PlayerDetailsScreen(playerData: provider.manOfTheMatchPlayerData, isHeaderShow: false,)
      ],
    // )
    // ,
    );
  }
}
