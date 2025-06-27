
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../theme/mythemcolor.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/SeriesController.dart';
import '../../session/SessionManager.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../../view/home/HomeView.dart';
import '../More/MoreScreen.dart';
import '../fixtures/FixturesDetailsScreen.dart';
import '../fixtures/series/FixturesSeriesScreen.dart';
import '../news/NewsScreen.dart';
import '../series/SeriesScreen.dart';
import 'HomeScreen.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});
  @override
  State<StatefulWidget> createState() => DashboardScreenState();
}
 GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 int selectedPosition = 0;
 List<Widget> listBottomWidget = [];

class DashboardScreenState extends State<DashboardScreen>{
  var ctime;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<HomeController>(context, listen: false).getHomeAdsData(context);
    });
    addHomePage();
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primary,
    ));
   return  WillPopScope(
     onWillPop: _onBackPressed,
     child: Scaffold(
       appBar: myStatusBar(),
       key: _scaffoldKey,
       bottomNavigationBar: myBottomNavigationBar()
       ,
       body: Builder(builder: (context) {
        return listBottomWidget[selectedPosition];
        }),
     ),
   );
  }

  BottomNavigationBar myBottomNavigationBar(){
    SeriesController seriesProvider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
     return BottomNavigationBar(
       showSelectedLabels: true,
       showUnselectedLabels: true,
       useLegacyColorScheme: false,
       selectedLabelStyle: TextStyle(
           fontSize: 12,
           fontWeight: FontWeight.w700,
           fontFamily: "b",
           color: isDarkTheme ? Colors.white : myprimarycolor.shade900),
       unselectedLabelStyle: const TextStyle(
           fontSize: 12,
           fontWeight: FontWeight.w500,
           fontFamily: "b",
           color: Colors.grey),
       items: [
         BottomNavigationBarItem(
             icon: Image.asset(
                 height: 20,
                 width: 20,
                 "assets/images/home.png",
                 color: Colors.grey),
             activeIcon: Image.asset(
                 height: 22,
                 width: 22,
                 "assets/images/home.png",
                 color: isDarkTheme ? Colors.white : myprimarycolor),
             label: ("Home")),
         BottomNavigationBarItem(
             icon: Image.asset(
                 height: 20,
                 width: 20,
                 "assets/images/trophy.png",
                 color: Colors.grey),
             activeIcon: Image.asset(
                 height: 22,
                 width: 22,
                 "assets/images/trophy.png",
                 color: isDarkTheme ? Colors.white : myprimarycolor),
             label: ("Series")),
         BottomNavigationBarItem(
             icon: Image.asset(
                 height: 20,
                 width: 20,
                 "assets/images/newspaper.png",
                 color: Colors.grey),
             activeIcon: Image.asset(
                 height: 22,
                 width: 22,
                 "assets/images/newspaper.png",
                 color: isDarkTheme ? Colors.white : myprimarycolor),
             label: ("News")),
         BottomNavigationBarItem(
             icon: Image.asset(
                 height: 20,
                 width: 20,
                 "assets/images/more1.png",
                 color: Colors.grey),
             activeIcon: Image.asset(
                 height: 22,
                 width: 22,
                 "assets/images/more1.png",
                 color: isDarkTheme ? Colors.white : myprimarycolor),
             label: ("More")),
       ],
       currentIndex: selectedPosition,
       type: BottomNavigationBarType.fixed,
       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
       elevation: 2,
       // backgroundColor: isDarkTheme ? Color(0XFFD12C7D) : Color(0XFFca2b83),
       // backgroundColor: isDarkTheme ? Color(0XFFD12C7D) : Color(0XFF302ebf),
       onTap: (position) {
         setState(() {
           selectedPosition = position;
           if (position == 0) {
           }
           if (position == 1) {

           }
           if (position == 2) {

           }
           if (position == 3) {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsScreen()));
             // selectedPosition = 0;
           }
         });
       },
     );
  }
  void addHomePage() {
    listBottomWidget.add(const HomeView());
    listBottomWidget.add(const FixturesSeriesScreen());
    // listBottomWidget.add(const SeriesScreen());
    // listBottomWidget.add(const FixturesDetailsScreen());
    listBottomWidget.add(const NewsScreen());
    listBottomWidget.add(const MoreScreen());
  }

  Future<bool> _onBackPressed() {
    if (selectedPosition != 0) {
      setState(() {
        selectedPosition = 0;
      });
      return Future.value(false); // Prevents the default back button behavior
    }
    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime) > const Duration(seconds: 2)) {
      //add duration of press gap
      ctime = now;
      showToast('Press Back Button Again to Exit');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
