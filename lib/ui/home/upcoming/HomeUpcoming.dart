import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../commonUi/CommonUi.dart';

class HomeUpcoming extends StatefulWidget {
  const HomeUpcoming({super.key});

  @override
  State<StatefulWidget> createState() => HomeUpcomingState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
bool haveRecentReload = false;
List<Widget> listBottomWidget = [];

class HomeUpcomingState extends State<HomeUpcoming> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
        Provider.of<HomeController>(context, listen: false).getUpcomingMatchesList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    // provider.haveRecentReload ? provider.recentMListLoading = true : provider.recentMListLoading = false;
    Provider.of<HomeController>(context, listen: false).upcomingMListLoading = true;
    return Consumer<HomeController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: addBody()),
            ],
          ),
        ),
      );
    });
  }

  Widget addBody() {
    double teamWidth = 35;
    HomeController provider = Provider.of(context, listen: false);
    return provider.upcomingMListLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : SizedBox(
      child: provider.upcomingMatchesList.isEmpty
          ? const Center(child: Text("No Data Found"))
          : ListView(
        children: [
          matchDateWiseFilter(context, provider.upcomingMatchesList),
          /*...provider.recentMatchesList.asMap().entries.map((entry){
                        final index = entry.key;
                        final pData = entry.value;
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
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${e["matchs"]}, ${e["venue"]}" ?? "hi",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: teamWidth,
                                                    height: teamWidth,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(teamWidth/2),
                                                        border: Border.all(color: Colors.grey.shade300,width: 2)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        imageUrl: e["team_a_img"] ??
                                                            'https://www.google.com.au/image_url.png',
                                                        imageBuilder: (context,
                                                            imageProvider) =>
                                                            Container(
                                                              height: teamWidth,
                                                              width: teamWidth,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                        placeholder: (context, url) =>
                                                            Container(
                                                              alignment: Alignment.center,
                                                              child: Image.asset(
                                                                "assets/images/logo.png",
                                                                height: teamWidth,
                                                                width: teamWidth,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                        errorWidget:
                                                            (context, url, error) =>
                                                            Image.asset(
                                                              "assets/images/logo.png",
                                                              height: teamWidth,
                                                              width: teamWidth,
                                                              fit: BoxFit.cover,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${e["team_a_short"]}" ??
                                                        "hi",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: teamWidth,
                                                    height: teamWidth,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(teamWidth/2),
                                                        border: Border.all(color: Colors.grey.shade300,width: 2)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        imageUrl: e["team_b_img"] ??
                                                            'https://www.google.com.au/image_url.png',
                                                        imageBuilder: (context,
                                                            imageProvider) =>
                                                            Container(
                                                              height: teamWidth,
                                                              width: teamWidth,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                        placeholder: (context, url) =>
                                                            Container(
                                                              alignment: Alignment.center,
                                                              child: Image.asset(
                                                                "assets/images/logo.png",
                                                                height: teamWidth,
                                                                width: teamWidth,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                        errorWidget:
                                                            (context, url, error) =>
                                                            Image.asset(
                                                              "assets/images/logo.png",
                                                              height: teamWidth,
                                                              width: teamWidth,
                                                              fit: BoxFit.cover,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${e["team_b_short"]}" ??
                                                        "hi",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                width: 2,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Start at:",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(fontSize: 10),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    e["match_date"],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(fontSize: 13),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    e["match_time"],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            side: BorderSide(
                                                width: 1,
                                                color:
                                                Theme.of(context).hintColor),
                                          ),
                                          child: Text(
                                            "Click for prediction",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      e["result"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                          fontSize: 12,
                                          color: myprimarycolor.shade200),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      }),*/
        ],
      ),
    );
  }
}
