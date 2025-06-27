import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:metroscoresliveline/controllers/SeriesController.dart';
import 'package:metroscoresliveline/ui/home/finished/HomeFinishedNew.dart';
import 'package:metroscoresliveline/ui/home/live/LiveMatchList.dart';
import 'package:provider/provider.dart';
import 'package:metroscoresliveline/ui/home/prediction/Prediction.dart';
import 'package:metroscoresliveline/ui/home/upcoming/HomeUpcomingNew.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../theme/mythemcolor.dart';
import '../../Constant.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../controllers/MatchDetailController.dart';
import '../../controllers/NewsController.dart';
import '../../ui/commonUi/CommonUi.dart';
import '../../ui/match_detail/MatchDetailsScreen.dart';
import '../../ui/news/NewsDetailScreen.dart';
import '../../ui/series/SeriesScreen.dart';
import '../../utils/common_color.dart';
import '../../utils/styleUtil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  AppUpdateInfo? _updateInfo;

  bool _flexibleUpdateAvailable = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    HomeController provider = Provider.of(context, listen: false);
    SeriesController sProvider = Provider.of(context, listen: false);
    Future.delayed(const Duration(milliseconds: 500), () {
      provider.getHomeList(context);
      provider.getLiveMatchList(context);
      sProvider.getSeriesList(context);
      Provider.of<NewsController>(context, listen: false).getNewsList(context);
    });
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<HomeController>(context, listen: false).getHomeAdsData(context);
    });
    Future.delayed(const Duration(seconds: 2), () {
      checkForUpdate();
      if (provider.homeOpenAppAds.isNotEmpty) {
        showHomePopup();
      }
    });
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  // Add the checkForUpdate function
  Future<void> checkForUpdate() async {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate()
          .then((info) {
            setState(() {
              _updateInfo = info;
              _updateInfo?.updateAvailability ==
                      UpdateAvailability.updateAvailable
                  ? performImmediateUpdate() // Call the extracted function
                  : print('Update not available');
            });
          })
          .catchError((e) {
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
  void dispose() {
    _animationController.dispose(); // ✅ Dispose to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LiveMatchController liveMatchController = Provider.of(
      context,
      listen: false,
    );
    liveMatchController.stopFetchingMatchInfo();
    return Consumer<HomeController>(
      builder: (context, myData, _) {
        return Scaffold(
          body: SafeArea(
            child: mContainer(
              context: context,
              child: Column(
                children: [
                  appbarView(),
                  Expanded(child: addBody()),
                  instagramFollowAds(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget appbarView() {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Color? containerColor =
        isDarkTheme ? Colors.black54 : myprimarycolor.shade400;
    HomeController provider = Provider.of(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
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
                // Image.asset("assets/images/c_logo.png", height: 50,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gText(context, "Metro Live Line"),
                  ],
                ),
                InkWell(
                  onTap: () {
                    onInviteFriends();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(Icons.share, size: 25),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          hrLightWidget(context),
        ],
      ),
    );
  }

  Widget addBody() {
    HomeController provider = Provider.of(context, listen: false);
    return ListView(
      children: [
        seriesView(),
        if (provider.liveDataList.isNotEmpty)
          Column(
            children: [
              liveMListView(),
            ],
          ),
        if (provider.homeDataFilterDateWise.isNotEmpty)
          Column(
            children: [
              // SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcoming Matches",
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeUpcomingNew(),
                        ),
                      );
                        },
                      child: Text(
                        "View all",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3,),
              upcomingMListView(),
            ],
          ),
        const SizedBox(height: 15),
        seriesListView(),
        const SizedBox(height: 15),
        newsView(),
      ],
    );
  }

  Widget seriesView() {
    return Column(
      children: [
        SizedBox(height: 10),
        // sliderView(),
        // SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveMatchList(),
                      ),
                    );
                  },
                  child: buttonView("live", "Live"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 1, child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeUpcomingNew(),
                      ),
                    );
                  },child: buttonView("upcoming", "Upcoming"))),
              const SizedBox(width: 10),
              Expanded(flex: 1, child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeFinishedNew(),
                      ),
                    );
                  },child: buttonView("finished", "Finished"))),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget liveMListView() {
    MatchDetailController matchDetailController = Provider.of(
      context,
      listen: false,
    );
    double teamWidth = 35;
    HomeController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: provider.liveDataList.length,
        itemBuilder: (BuildContext context, int index) {
          Map e = provider.liveDataList[index];
          return Row(
            children: [
              liveMatchItem(context, e, true),
              if (index == provider.liveDataList.length - 1)
                SizedBox(width: 15),
            ],
          );
        },
      ),
    );
  }

  Widget upcomingMListView() {
    HomeController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: List.generate(
              provider.homeDataFilterDateWise.length, (index) {
            int crossAxisCellCount = 1;
            double mainAxisCellCount = 2.52;
            Map e = provider.homeDataFilterDateWise[index];
            return StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCellCount,
              mainAxisCellCount: mainAxisCellCount,
              child: homeUpcomingMatchItem(context, e, false),
            );
          }),
        ),
      ),
    );
  }

  Widget seriesListView() {
    SeriesController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 0,
          children: List.generate(
              provider.seriesListData.length, (index) {
            int crossAxisCellCount = 1;
            double mainAxisCellCount = 1;
            Map e = provider.seriesListData[index];
            return StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCellCount,
              mainAxisCellCount: mainAxisCellCount,
              child: sCard(e),
            );
          }),
        ),
      ),
    );
  }


  Widget newsView() {
    double myWidth = MediaQuery.of(context).size.width-30;
    double myHeight = 180;
    double myWidth1 = 90;
    double myHeight1 = 85;
    NewsController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        if(provider.newsData.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Latest News",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900, fontFamily: "sb", fontSize: 18,),
              ),
              Visibility(
                visible: false,
                child: Text("View All",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600, fontFamily: "sb", fontSize: 16,),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        ...provider.newsData.asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;
          return index == 0 ? InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(newsData: e)));
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: e["image"] ??'https://www.daadiskitchen.com.au/image_url.png',
                          imageBuilder: (context, imageProvider) => Container(
                            height: myHeight,
                            width: myWidth,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                //image size fill
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: myHeight,
                              width: myWidth,
                              fit: BoxFit.fill,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/logo.png",
                            height: myHeight,
                            width: myWidth,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e["title"] ?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 0,),
                            Text(
                              e["description"] ?? "",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  e["pub_date"] ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(newsData: e)));
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: e["image"] ??'https://www.daadiskitchen.com.au/image_url.png',
                          imageBuilder: (context, imageProvider) => Container(
                            height: myHeight1,
                            width: myWidth1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                //image size fill
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: myHeight1,
                              width: myWidth1,
                              fit: BoxFit.fill,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/logo.png",
                            height: myHeight1,
                            width: myWidth1,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e["title"] ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                e["description"] ?? "",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    e["pub_date"] ?? "",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget buttonView(String imgName, String title) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      alignment: Alignment.center,
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/$imgName.png",
            height: 20,
            width: 20,
            color: isDarkTheme ? Colors.white : Color(0XFFEF5151),
          ),
          SizedBox(width: 10,),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "b",
            ),
          ),
        ],
      ),
    );
  }

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  Widget sliderView() {
    SeriesController provider = Provider.of(context, listen: false);
    late List<Widget> imageSliders =
        provider.seriesListData.map((item) => sCard(item)).toList();

    return Stack(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            height: 120,
            viewportFraction: 0.92,
            aspectRatio: 1.6,
            // viewportFraction: .9,
            // aspectRatio: 16/9,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget sCard(Map item) {
    SeriesController provider = Provider.of(context, listen: false);
    double myHeight = 120;
    double myWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        provider.selectedIndex = item["series_id"];
        provider.selectItem(0, item);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SeriesScreen(),
          ),
        );
      },
      child: Container(
        child: setCachedImageSeries(item["image"], myHeight, myWidth, 15),
      ),
    );
  }

  Future<void> showHomePopup() async {
    HomeController provider = Provider.of(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height / 2.5;
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
                  onTap: () {
                    openWhatsApp(provider.homeOpenAppAds[0]["url"]);
                  },
                  child: setCachedImage(
                    "${provider.homeOpenAppAds[0]["image"]}",
                    screenHeight,
                    screenWidth,
                    4,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.close_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
