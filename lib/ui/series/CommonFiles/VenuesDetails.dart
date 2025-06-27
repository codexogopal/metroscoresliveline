
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';

class VenuesDetails extends StatefulWidget{
  const VenuesDetails({super.key});
  @override
  State<StatefulWidget> createState() => VenuesDetailsState();
}

class VenuesDetailsState extends State<VenuesDetails>{

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    return Consumer<SeriesController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBars.myAppBar("", context, true),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: addBody()),
              instagramFollowAds(context)
            ],
          ),
        ),
      );
    });
  }

  Widget addBody() {
    double myWidth = MediaQuery.of(context).size.width;
    double myHeight = 230;
    SeriesController provider = Provider.of(context, listen: false);
    Map pData = provider.venueDataData;
    return ListView(
      children: [
        CachedNetworkImage(
          imageUrl: pData["image"] ??'https://www.daadiskitchen.com.au/image_url.png',
          imageBuilder: (context, imageProvider) => Container(
            height: myHeight,
            width: myWidth,
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
              height: myHeight,
              width: myWidth,
              fit: BoxFit.cover,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/logo.png",
            height: myHeight,
            width: myWidth,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                pData["name"] ?? "",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "Venues Information",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16, color: myprimarycolor),
              ),
            ),
            detailRow("Opened", pData["opened"]),
            hrLightWidget(context),
            detailRow("Capacity", pData["capacity"]),
            hrLightWidget(context),
            detailRow("Known as", pData["known_as"]),
            hrLightWidget(context),
            detailRow("Ends", pData["ends"]),
            hrLightWidget(context),
            detailRow("Location", pData["location"]),
            hrLightWidget(context),
            detailRow("Time Zone", pData["time_zone"]),
            hrLightWidget(context),
            detailRow("Home to", pData["home_to"]),
            hrLightWidget(context),
            detailRow("Floodlights", pData["floodlights"]),
            hrLightWidget(context),
            detailRow("Curator", pData["curator"]),
            const SizedBox(height: 15,),
            HtmlWidget(pData["profile"],textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),),
            const SizedBox(height: 50,),
          ],
        ),
      ],
    );
  }

  Widget detailRow(String title, String detail){
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontFamily: "b", fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      detail,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
