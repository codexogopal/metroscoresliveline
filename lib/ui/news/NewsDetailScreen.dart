import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/NewsController.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class NewsDetailScreen extends StatefulWidget {
  final Map newsData;
  const NewsDetailScreen({super.key, required this.newsData});

  @override
  State<StatefulWidget> createState() => NewsDetailScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class NewsDetailScreenState extends State<NewsDetailScreen> {


  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewsController provider = Provider.of(context, listen: false);
    return Consumer<NewsController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBars.myAppBar("", context, true),
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
    double myWidth = MediaQuery.of(context).size.width;
    double myHeight = 200;
    NewsController provider = Provider.of(context, listen: false);
    return provider.newsData.isEmpty
        ? const SizedBox(child: Text("No Data Found"))
        : ListView(
      children: [
        CachedNetworkImage(
          imageUrl: widget.newsData["image"] ??'https://www.com.au/image_url.png',
          imageBuilder: (context, imageProvider) => Container(
            height: myHeight,
            width: myWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
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
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Text(
                  widget.newsData["title"] ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontFamily: "b", fontSize: 14),
                ),
                const SizedBox(height: 10,),
                Text(
                  widget.newsData["pub_date"] ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 15,),
                HtmlWidget(widget.newsData["content"][0],textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),),
                const SizedBox(height: 15,),
              ],
            )
        ),
      ],
    );
  }


}
