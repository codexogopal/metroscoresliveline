import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:metroscoresliveline/utils/AppBars.dart';
import 'package:metroscoresliveline/utils/styleUtil.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../commonUi/CommonUi.dart';
import '../../series/SeriesScreen.dart';

class FixturesSeriesScreen extends StatefulWidget {
  const FixturesSeriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => FixturesSeriesScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
ScrollController _scrollController = ScrollController();
bool _isLoadingMore = false;

class FixturesSeriesScreenState extends State<FixturesSeriesScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<SeriesController>(
        context,
        listen: false,
      ).getSeriesForFixturesList(context);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  Future<void> _loadMoreData() async {
    // setState(() {
    //   _isLoadingMore = true;
    // });

    // await Provider.of<SeriesController>(context, listen: false).getSeriesForFixturesList(context);

    // setState(() {
    //   _isLoadingMore = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<SeriesController>(context, listen: false).seriesForFixtLoading = true;
    return Consumer<SeriesController>(
      builder: (context, myData, _) {
        return Scaffold(
          appBar: AppBars.myAppBar("Series", context, false),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: mContainer(context: context, child: addBody())),
                instagramFollowAds(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addBody() {
    SeriesController provider = Provider.of(context, listen: false);
    return provider.seriesForFixtLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.seriesForFixturesListData.isEmpty
        ? Center(child: emptyWidget(context))
        : ListView.builder(
          // controller: _scrollController,
          itemCount:
              provider.seriesForFixturesListData.length +
              (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.seriesForFixturesListData.length) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                matchItem(context, provider.seriesForFixturesListData[index]),
                if (index == provider.seriesForFixturesListData.length - 1)
                  SizedBox(height: 15),
              ],
            );
          },
        );
  }

  // isDateWise == ture (match will show date wise otherwise date will hide)
  Widget matchItem(BuildContext context, Map<String, dynamic> pData) {
    SeriesController provider = Provider.of(context, listen: false);
    List matchData = pData["data"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            pData["month_wise"] ?? "----",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        matchCard(matchData),
      ],
    );
  }

  Widget matchCard(List matchData) {
    SeriesController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    double myWidth1 = 80;
    double myHeight1 = 80;
    return Container(
      height: matchData.length < 3 ? 115 : 230,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StaggeredGrid.count(
          crossAxisCount: matchData.length < 3 ? 1 : 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          children: List.generate(matchData.length, (index) {
            int crossAxisCellCount = 1;
            double mainAxisCellCount = matchData.length < 3 ? 3.2 : 2.5;
            Map e = matchData[index];
            return StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCellCount,
              mainAxisCellCount: mainAxisCellCount,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // provider.selectedSeriesData = e;
                      provider.selectedIndex = e["series_id"];
                      provider.selectItem(0, e);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeriesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 2.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          setCachedImage(e["image"], myHeight1, myWidth1, 10),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e["series"] ?? "----",
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${"${e["total_matches"]} Matches" ?? "----"},${e["series_date"] ?? "----"}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 13,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Icon(Icons.navigate_next, size: 20, color: Theme.of(context).hintColor,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget matchCard1(BuildContext context, List matchData) {
    SeriesController provider = Provider.of(context, listen: false);
    double teamWidth = 35;
    double myWidth1 = 80;
    double myHeight1 = 80;
    return Column(
      children: [
        ...matchData.map((e) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // provider.selectedSeriesData = e;
                  /*provider.selectedIndex = e["series_id"];
                  provider.selectItem(0, e);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SeriesScreen()));*/
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      setCachedImage(e["image"], myHeight1, myWidth1, 10),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e["series"] ?? "----",
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${"${e["total_matches"]} Matches" ?? "----"},${e["series_date"] ?? "----"}",
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontSize: 13,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icon(Icons.navigate_next, size: 20, color: Theme.of(context).hintColor,)
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
