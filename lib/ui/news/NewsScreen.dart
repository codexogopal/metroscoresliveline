import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/LiveMatchControllers.dart';
import '../../controllers/NewsController.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import 'NewsDetailScreen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewsScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<NewsController>(context, listen: false).getNewsList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    NewsController provider = Provider.of(context, listen: false);
    LiveMatchController liveMatchController = Provider.of(context, listen: false);
    liveMatchController.stopFetchingMatchInfo();
    provider.newsLoading = true;
    return Consumer<NewsController>(builder: (context, myData, _) {
      return Scaffold(
        appBar: AppBars.myAppBar("Latest News", context, false),
        body: SafeArea(
          child: mContainer(
            context: context,
            child: Column(
              children: [
                Expanded(child: addBody()),
                instagramFollowAds(context)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget addBody() {
    NewsController provider = Provider.of(context, listen: false);
    return ListView(
      children: [
        // sliderView(),
        if(provider.newsData.isNotEmpty)
          topHighlights()
      ],
    );
  }

  Widget topHighlights() {
    NewsController provider = Provider.of(context, listen: false);
    double myHeight = 100;
    double myWidth = MediaQuery
        .of(context)
        .size
        .width / 1.2;
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: List.generate(
              provider.newsData.length, (index) {
              int crossAxisCellCount = 1;
              double mainAxisCellCount = 1.2;
              String dateTimeS = provider.newsData[index]["pub_date"];
              List timeL = dateTimeS.split("|");
              return StaggeredGridTile.count(
                crossAxisCellCount: crossAxisCellCount,
                mainAxisCellCount: mainAxisCellCount,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(newsData: provider.newsData[index])));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.0)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: provider.newsData[index]["image"] ??
                                  'https://www.google.com.au/image_url.png',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: myHeight,
                                    // width: myWidth,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 10),
                            child: Text(provider.newsData[index]["title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontSize: 13,
                                height: 20 / 13.0,
                                fontFamily: "ppr",
                                fontWeight: FontWeight.w500,
                              ),),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 0),
                                child: Text(
                                  timeL[0],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontSize: 12,
                                    height: 20 / 10.0,
                                    fontFamily: "ppr",
                                    color: Color.fromRGBO(119, 119, 119, 1),
                                    fontWeight: FontWeight.w500,
                                  ),),
                              ),
                              Visibility(
                                visible: false,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                    "assets/images/ic_share.png", height: 24,),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            ),
          ),
        ),
      ],
    );
  }

  Widget addBody11() {
    double myWidth = MediaQuery.of(context).size.width-30;
    double myHeight = 150;
    NewsController provider = Provider.of(context, listen: false);
    return provider.newsLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
      child: provider.newsData.isEmpty
          ? const SizedBox(child: Text("No Data Found"))
          : ListView(
              children: [
                ...provider.newsData.map((e) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(newsData: e)));
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            e["title"] ?? "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                        fit: BoxFit.fitWidth,
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
                              const SizedBox(height: 10,),
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e["description"] ?? "",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 15,)
              ],
            ),
    );
  }
}
