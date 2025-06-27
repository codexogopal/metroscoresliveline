
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class FixturesScreen extends StatefulWidget{
  const FixturesScreen({super.key});
  @override
  State<StatefulWidget> createState() => FixturesScreenState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
Map selectedSeriesData = {};
bool haveFixtureLoad = false;
List<Widget> listBottomWidget = [];

class FixturesScreenState extends State<FixturesScreen>{

  @override
  void initState() {
    selectedSeriesData = Provider.of<SeriesController>(context, listen: false).selectedSeriesData;
    haveFixtureLoad = Provider.of<SeriesController>(context, listen: false).haveFixturesReload;
    Map<String, String> fixturesDate = {
      "series_id" : selectedSeriesData["series_id"].toString()
    };
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if(haveFixtureLoad){
        Provider.of<SeriesController>(context, listen: false).getFixturesList(context, fixturesDate);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    provider.haveFixturesReload ? provider.fixturesListLoading = true : provider.fixturesListLoading = false;
    return Consumer<SeriesController>(builder: (context, myData, _){
      return Scaffold(
        body: SafeArea(
          child: mContainer(
            context: context,
            child: Column(
              children: [
                Expanded(child: addBody()),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget addBody(){
    double teamWidth = 35;
    SeriesController provider = Provider.of(context, listen: false);
    return provider.fixturesListLoading ? const Center(
      child: CircularProgressIndicator(),) : SizedBox(
      child: provider.seriesFixturesListData.isEmpty ? emptyWidget(context) : ListView(
        children: [
          matchDateWiseFilter(context, provider.seriesFixturesListData),
          /*...provider.seriesFixturesListData.asMap().entries.map((entry){
            final index = entry.key;
            final pData = entry.value;
            List matchData = pData["data"];
            return  Column(
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
                        color: Theme.of(context).colorScheme.primaryContainer
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${e["matchs"]}, ${e["venue"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: teamWidth,
                                        height: teamWidth,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(teamWidth/2),
                                            border: Border.all(color: Colors.grey.shade300,width: 2)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(teamWidth/2),
                                          child: CachedNetworkImage(
                                            imageUrl: e["team_a_img"] ??'https://www.google.com.au/image_url.png',
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
                                      const SizedBox(width: 10,),
                                      Text("${e["team_a_short"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            imageUrl: e["team_b_img"] ??'https://www.google.com.au/image_url.png',
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
                                      const SizedBox(width: 10,),
                                      Text("${e["team_b_short"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    width: 2,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Start at:", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 10),),
                                      const SizedBox(height: 3,),
                                      Text(e["match_date"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13),),
                                      const SizedBox(height: 3,),
                                      Text(e["match_time"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: (){},
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
                            Visibility(
                              visible: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(e["fav_team"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),),
                                      const SizedBox(width: 8,),
                                      Container(
                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Text(e["min_rate"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),)),
                                      const SizedBox(width: 8,),
                                      Container(
                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Text(e["max_rate"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),*/
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
  Widget addBody1(){
    double teamWidth = 35;
    SeriesController provider = Provider.of(context, listen: false);
    return provider.fixturesListLoading ? const Center(
      child: CircularProgressIndicator(),) : SizedBox(
      child: provider.seriesFixturesListData.isEmpty ? emptyWidget(context) : ListView(
        children: [
          ...provider.seriesFixturesListData.map((e) {
            return SizedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${e["matchs"]}, ${e["venue"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: teamWidth,
                                      height: teamWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(teamWidth/2),
                                        border: Border.all(color: Colors.grey,width: 2)
                                      ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(teamWidth/2),
                                      child: CachedNetworkImage(
                                        imageUrl: e["team_a_img"] ??'https://www.google.com.au/image_url.png',
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
                                  const SizedBox(width: 10,),
                                  Text("${e["team_a_short"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: teamWidth,
                                    height: teamWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(teamWidth/2),
                                        border: Border.all(color: Colors.grey,width: 2)
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: e["team_b_img"] ??'https://www.google.com.au/image_url.png',
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
                                  const SizedBox(width: 10,),
                                  Text("${e["team_b_short"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                width: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Start at:", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 10),),
                                  const SizedBox(height: 3,),
                                  Text(e["match_date"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13),),
                                  const SizedBox(height: 3,),
                                  Text(e["match_time"], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: (){},
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
                        Visibility(
                          visible: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(e["fav_team"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),),
                                  const SizedBox(width: 8,),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text(e["min_rate"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),)),
                                  const SizedBox(width: 8,),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text(e["max_rate"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }


}