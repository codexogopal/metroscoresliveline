import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/NewsController.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';

class AboutPageScreen extends StatefulWidget {
  final String textData;
  final String title;
  const AboutPageScreen({super.key, required this.textData, required this.title});

  @override
  State<StatefulWidget> createState() => AboutPageScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class AboutPageScreenState extends State<AboutPageScreen> {


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
        appBar: AppBars.myAppBar(widget.title, context, true),
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
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),
                HtmlWidget(widget.textData,textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
                const SizedBox(height: 15,),
              ],
            )
        ),
      ],
    );
  }


}
