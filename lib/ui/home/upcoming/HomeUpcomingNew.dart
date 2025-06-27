import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/HomeController.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';
import '../../match_detail/MatchDetailsScreen.dart';

class HomeUpcomingNew extends StatefulWidget {
  const HomeUpcomingNew({super.key});
  @override
  State<StatefulWidget> createState() => HomeUpcomingNewState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeUpcomingNewState extends State<HomeUpcomingNew> {
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _page = 0;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<HomeController>(context, listen: false).getUpcomingMatchesList(context);
    });

/*    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
        _loadMoreData();
      }
    });*/
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    _page++;
    await Provider.of<HomeController>(context, listen: false).getUpcomingMatchesList(context);

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    // provider.upcomingMListLoading = true;
    return Consumer<HomeController>(builder: (context, myData, _) {
      return Scaffold(
        appBar: AppBars.myAppBar("Upcoming Matches", context, true),
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
    HomeController provider = Provider.of(context, listen: false);
    return provider.upcomingMListLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.upcomingMatchesList.isEmpty
        ? emptyWidget(context)
        : ListView.builder(
      controller: _scrollController,
      itemCount: provider.upcomingMatchesList.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.upcomingMatchesList.length) {
          return Center(child: CircularProgressIndicator());
        }

        return matchItem(context, provider.upcomingMatchesList[index], true, "2", true);
      },
    );
  }

/*  Widget matchItem(BuildContext context, Map<String, dynamic> pData) {
    MatchDetailController matchDetailController = Provider.of(context, listen: false);
    double teamWidth = 35;
    List matchData = pData["data"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            pData["date_wise"] ?? "hi",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
        ...matchData.map((e) {
          return InkWell(
            onTap: (){
              matchDetailController.matchInfo = e;
              Navigator.push(context, MaterialPageRoute(builder: (context) => MatchDetailsScreen(matchId: e["match_id"].toString())));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${e["matchs"]}, ${e["venue"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith()),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            teamInfo(context, e["team_a_img"], e["team_a_short"], teamWidth),
                            const SizedBox(height: 10),
                            teamInfo(context, e["team_b_img"], e["team_b_short"], teamWidth),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: matchStatus(context, e),
                      ),
                    ],
                  ),
                  if (e["match_status"] != "Finished") const SizedBox(height: 20),
                  if (e["match_status"] != "Finished") matchActions(context, e),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget teamInfo(BuildContext context, String imgUrl, String teamShort, double teamWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: teamWidth,
          height: teamWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(teamWidth / 2),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(teamWidth / 2),
            child: CachedNetworkImage(
              imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
              imageBuilder: (context, imageProvider) => Container(
                height: teamWidth,
                width: teamWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: teamWidth,
                  width: teamWidth,
                  fit: BoxFit.cover,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/logo.png",
                height: teamWidth,
                width: teamWidth,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(teamShort ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith()),
      ],
    );
  }

  Widget matchStatus(BuildContext context, Map<String, dynamic> e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 40,
          color: Theme.of(context).colorScheme.secondaryContainer,
          width: 2,
        ),
        e["match_status"] == "Finished"
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Finished', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13)),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Start at:", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 10)),
            const SizedBox(height: 3),
            Text(e["match_date"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13)),
            const SizedBox(height: 3),
            Text(e["match_time"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget matchActions(BuildContext context, Map<String, dynamic> e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(width: 1, color: Theme.of(context).hintColor),
          ),
          child: Text(
            "Click for prediction",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(),
          ),
        ),
        if (e.containsKey("fav_team"))
          Visibility(
            visible: e["fav_team"] != "",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(e["fav_team"] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(e["min_rate"].toString() ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(e["max_rate"].toString() ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }*/
}