
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../../controllers/SeriesController.dart';
import '../../commonUi/CommonUi.dart';

class TeamPlayersList extends StatefulWidget{
  final String teamId;
  final String teamName;
  const TeamPlayersList({super.key, required this.teamId, required this.teamName});
  @override
  State<StatefulWidget> createState() => TeamPlayersListState();
}

class TeamPlayersListState extends State<TeamPlayersList>{

  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 200)).then((_) {
        Provider.of<HomeController>(context, listen: false).getPlayerListByTeamId(context, widget.teamId.toString());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    return Consumer<HomeController>(builder: (context, myData, _){
      return Material(
        child: SizedBox(
          height: MediaQuery.of(context).size.height-70,
          child: provider.isLoadingPlayer ? const Center(child: CircularProgressIndicator(),) :
          provider.teamData.isEmpty ? emptyWidgetWithExit(context)
              : addBody(),
        ),
      );
    });
  }

  Widget addBody(){
    HomeController provider = Provider.of(context, listen: false);
    double teamWidth = 30;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 50,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50)
            ),
            child: Text(""),
          )],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(widget.teamName ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Text("Close", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade300,thickness: 1,),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(5),
            crossAxisSpacing: 1.5,
            mainAxisSpacing: MediaQuery.of(context).size.width / 40,
            crossAxisCount: 2,
            childAspectRatio: 10.0 / 3.0,
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            children: [
              ...provider.teamData.map((e) {
                return InkWell(
                  onTap: (){
                    SeriesController provider = Provider.of(context, listen: false);
                    Map<String, String> playerId = {
                      "player_id" : e["player_id"].toString()
                    };
                    provider.getPlayerDataById(context, playerId);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayerDetailsScreen()));
                  },
                  child: Column(
                    children: [
                      // Divider(color: Colors.grey.shade200, thickness: 1,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: e["image"] ?? 'https://www.google.com.au/image_url.png',
                                imageBuilder: (context, imageProvider) => Container(
                                  height: teamWidth,
                                  width: teamWidth,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    height: teamWidth,
                                    width: teamWidth,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/logo.png",
                                  height: teamWidth,
                                  width: teamWidth,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width/3,
                                      child: Text("${e["name"]}" ?? "hi",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13), overflow: TextOverflow.ellipsis,)),
                                  Text("${e["play_role"]}" ?? "hi", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 11,),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox(width: MediaQuery.of(context).size.width/2.2,child: Divider(color: Colors.grey.shade300,thickness: 1,)))
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }


}