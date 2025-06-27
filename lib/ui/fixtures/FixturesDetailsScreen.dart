import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metroscoresliveline/ui/fixtures/series/FixturesSeriesScreen.dart';
import 'package:metroscoresliveline/ui/fixtures/teams/FixturesTeamsScreen.dart';

import '../../../theme/mythemcolor.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../utils/styleUtil.dart';
import '../commonUi/CommonUi.dart';
import '../home/finished/HomeFinishedNew.dart';
import '../home/live/LiveMatchList.dart';
import 'day/DayFixturesScreen.dart';

class FixturesDetailsScreen extends StatefulWidget {
  const FixturesDetailsScreen({super.key});

  @override
  State<StatefulWidget> createState() => FixturesDetailsScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class FixturesDetailsScreenState extends State<FixturesDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    LiveMatchController liveMatchController = Provider.of(context, listen: false);
    liveMatchController.stopFetchingMatchInfo();
    provider.fixturesDayListLoading = true;
    return Consumer<HomeController>(builder: (context, myData, _) {
      return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          body: SafeArea(
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

  Widget appbarView() {
    HomeController provider = Provider.of(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fixtures",
                  style: textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: "b"),
                ),
                InkWell(
                  onTap: (){
                    onInviteFriends();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            // margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
              labelColor: Theme.of(context).tabBarTheme.labelColor,
              unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
              /*indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(50),
              ),*/
              tabs: const <Widget>[
                Tab(
                  child: Text(
                    'Day',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "os",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Series',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "os",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Teams',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "os",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addBody() {
    return const TabBarView(
      children: <Widget>[
        DayFixturesScreen(),
        FixturesSeriesScreen(),
        FixturesTeamsScreen(),
        /*HomeMatch(),
        HomeUpcomingNew(),*/
      ],
    );
  }
}
