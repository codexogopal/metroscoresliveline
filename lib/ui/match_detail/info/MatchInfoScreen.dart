
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:metroscoresliveline/ui/match_detail/info/PlayIngXIScreen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/MatchDetailController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';
import '../../match_detail/MatchDetailsScreen.dart';

class MatchInfoScreen extends StatefulWidget{
  final String matchId;
  const MatchInfoScreen({super.key, required this.matchId});
  @override
  State<StatefulWidget> createState() => MatchInfoScreenState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MatchInfoScreenState extends State<MatchInfoScreen>{

  @override
  void initState() {

    Provider.of<MatchDetailController>(context, listen: false).isLoadingInfo = true;
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Map<String, String> matchData = {
        "match_id" : widget.matchId.toString()
      };
      Provider.of<MatchDetailController>(context, listen: false).getMatchInfoById(context, matchData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MatchDetailController provider = Provider.of(context, listen: false);
    return Consumer<MatchDetailController>(builder: (context, myData, _){
      return Scaffold(
        body: SafeArea(
          child: mContainer(
              context: context,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
              child: addBody()
          )
        ),
        ),
      );
    });
  }

  Widget addBody(){
    double teamImgWidth = 35;
    MatchDetailController provider = Provider.of(context, listen: false);
    return provider.isLoadingInfo ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 2.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(provider.matchInfo["matchs"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(),),
                const SizedBox(height: 5,),
                Text('${provider.matchInfo["team_a_short"]} VS ${provider.matchInfo["team_b_short"]}' ?? "", style: Theme.of(context).textTheme.titleMedium,),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
              children: [
                Image.asset("assets/images/ic_calendar.png",height: 18,color: Theme.of(context).hintColor.withOpacity(0.4),),
                const SizedBox(width: 10,),
                Text('${provider.matchInfo["match_time"]}, ${provider.matchInfo["match_date"]}' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
              children: [
                Image.asset("assets/images/ic_location.png",height: 18,color: Theme.of(context).hintColor.withOpacity(0.4),),
                const SizedBox(width: 10,),
                Expanded(child: Text('${provider.matchInfo["venue"]}' ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                )),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          if(provider.matchInfo["match_status"].toString() != "1")
            matchStartedData(),
          if(provider.matchInfo["match_status"].toString() != "3" && provider.matchInfo.containsKey("venue_weather"))
          weatherWidget(),
          const SizedBox(height: 15,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text("Playing XI",  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontFamily: "sb",
                fontSize: 18),),
          ),
          const SizedBox(height: 10,),
          InkWell(
            onTap: (){
              // provider.squadsDetailBottomSheet(context, widget.matchId.toString(), "team_a");
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayIngXIScreen(matchId: widget.matchId.toString(), clickedFrom: "team_a")));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                  Row(
                    children: [
                      Container(
                        width: teamImgWidth,
                        height: teamImgWidth,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(teamImgWidth / 2),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(teamImgWidth / 2),
                          child: CachedNetworkImage(
                            imageUrl:
                            provider.matchInfo["team_a_img"] ?? 'https://cricketchampion.co.in/webroot/img/teams/13.png',
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  height: teamImgWidth,
                                  width: teamImgWidth,
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
                                height: teamImgWidth,
                                width: teamImgWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/logo.png",
                              height: teamImgWidth,
                              width: teamImgWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text('${provider.matchInfo["team_a"]}' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                    ],
                  ),
                  Icon(Icons.navigate_next_outlined, size: 25,color: Theme.of(context).hintColor,)
                ],
              ),
            ),
          ),
          const SizedBox(height: 5,),
          InkWell(
            onTap: (){
              // provider.squadsDetailBottomSheet(context, widget.matchId.toString(), "team_b");
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayIngXIScreen(matchId: widget.matchId.toString(), clickedFrom: "team_b")));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                  Row(
                    children: [
                      Container(
                        width: teamImgWidth,
                        height: teamImgWidth,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(teamImgWidth / 2),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(teamImgWidth / 2),
                          child: CachedNetworkImage(
                            imageUrl:
                            provider.matchInfo["team_b_img"] ?? 'https://cricketchampion.co.in/webroot/img/teams/13.png',
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  height: teamImgWidth,
                                  width: teamImgWidth,
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
                                height: teamImgWidth,
                                width: teamImgWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/logo.png",
                              height: teamImgWidth,
                              width: teamImgWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text('${provider.matchInfo["team_b"]}' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                    ],
                  ),
                  Icon(Icons.navigate_next_outlined, size: 25,color: Theme.of(context).hintColor,)
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          /*Text("Stats",  style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: "sb",
              fontSize: 18),),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primaryContainer
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Match Info' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                Icon(Icons.navigate_next_outlined, size: 25,color: Theme.of(context).hintColor,)
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primaryContainer
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pitch & Venue' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                Icon(Icons.navigate_next_outlined, size: 25,color: Theme.of(context).hintColor,)
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primaryContainer
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Stats' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                Icon(Icons.navigate_next_outlined, size: 25,color: Theme.of(context).hintColor,)
              ],
            ),
          ),
          const SizedBox(height: 15,),*/
        ],
      ),
    );
  }

  Widget weatherWidget(){
    MatchDetailController provider = Provider.of(context, listen: false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Map venueWeather = provider.matchInfo["venue_weather"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Weather Report", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),),
              Text(" (${provider.matchInfo["place"]})" ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18,color: isDarkTheme ? Colors.grey : Colors.black54),),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/ic_weather.png", height: 35,),
                  const SizedBox(width: 5,),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: venueWeather["temp_c"].toString() ?? "",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, -10),
                            child: Text(
                              '°C',
                              textScaleFactor: 0.7,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("${venueWeather["wind_mph"]} m/h", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                      Text("Wind Speed", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    children: [
                      Text("${venueWeather["humidity"]}%", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                      Text("Humidity", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                    ],
                  ),
                ],
              ),

            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${venueWeather["weather"]}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${venueWeather["cloud"]}%", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                  Text("Rain Chance", style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget matchStartedData(){
    MatchDetailController provider = Provider.of(context, listen: false);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('TOSS' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
              const SizedBox(height: 5,),
              Text(provider.matchInfo["toss"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 12,letterSpacing: 0.1),),
            ],
          ),
        ),
        if(provider.matchInfo['umpire'] != "")
        const SizedBox(height: 10,),
        if(provider.matchInfo['umpire'] != "")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('UMPIRE' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
              const SizedBox(height: 5,),
              Text(provider.matchInfo["umpire"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 12,letterSpacing: 0.1),),
            ],
          ),
        ),
        if(provider.matchInfo['third_umpire'] != "")
        const SizedBox(height: 10,),
        if(provider.matchInfo['third_umpire'] != "")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('3RD UMPIRE' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
              const SizedBox(height: 5,),
              Text(provider.matchInfo["third_umpire"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 12,letterSpacing: 0.1),),
            ],
          ),
        ),
          if(provider.matchInfo['referee'] != "")
        const SizedBox(height: 10,),
        if(provider.matchInfo['referee'] != "")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('REFREE' ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
              const SizedBox(height: 5,),
              Text(provider.matchInfo["referee"] ?? "", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 12,letterSpacing: 0.1),),
            ],
          ),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }


}