import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:metroscoresliveline/ui/home/prediction/Prediction.dart';
import 'package:metroscoresliveline/ui/home/upcoming/HomeUpcomingNew.dart';

import '../../../theme/mythemcolor.dart';
import '../../Constant.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../utils/styleUtil.dart';
import '../commonUi/CommonUi.dart';
import 'finished/HomeFinishedNew.dart';
import 'home/HomeMatch.dart';
import 'live/LiveMatchList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class HomeScreenState extends State<HomeScreen> {
  AppUpdateInfo? _updateInfo;

  bool _flexibleUpdateAvailable = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkForUpdate();
      HomeController provider = Provider.of(context, listen: false);
      if(provider.homeOpenAppAds.isNotEmpty){
        showHomePopup();
      }
    });
  }
  // Add the checkForUpdate function
  Future<void> checkForUpdate() async {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        setState(() {
          _updateInfo = info;
          _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
              ? performImmediateUpdate() // Call the extracted function
              : print('Update not available');
        });
      }).catchError((e) {
        print('InAppUpdateError2 $e');
      });
    }
  }

  void performImmediateUpdate() {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      // print("helllo ${e.toString()}");
      return AppUpdateResult.inAppUpdateFailed;
    });
  }
  @override
  Widget build(BuildContext context) {
    LiveMatchController liveMatchController = Provider.of(context, listen: false);
    liveMatchController.stopFetchingMatchInfo();
    return Consumer<HomeController>(builder: (context, myData, _) {
      return DefaultTabController(
        length: 5,
        initialIndex: 1,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                appbarView(),
                Expanded(
                  child: addBody(),
                ),
                instagramFollowAds(context)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget appbarView() {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Color? containerColor = isDarkTheme ? Colors.black54 : myprimarycolor.shade400;
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
                  Constant.appName,
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
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,),
            // decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary),
            child: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
              labelColor: Theme.of(context).tabBarTheme.labelColor,
              unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
              /*indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(50),
              ),*/
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Live (${provider.liveDataList.length.toString()})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "b",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "b",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "b",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Finished',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "b",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Prediction',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "b",
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
        LiveMatchList(),
        HomeMatch(),
        HomeUpcomingNew(),
        HomeFinishedNew(),
        Prediction()
      ],
    );
  }


  Future<void> showHomePopup() async {
    HomeController provider = Provider.of(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height/2.5;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          insetPadding: const EdgeInsets.all(30),
          child: Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.zero, // Remove all padding
              child: Stack(
                children: [
                  InkWell(
                      onTap: (){
                        openWhatsApp(provider.homeOpenAppAds[0]["url"]);
                      },
                      child: setCachedImage("${provider.homeOpenAppAds[0]["image"]}", screenHeight, screenWidth, 4)
                  ),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: const Icon(Icons.close_outlined, color: Colors.white,)
                        ),
                      )
                  )
                ],
              )
          ),
        );
      },
    );
  }

}
