
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../commonUi/CommonUi.dart';
import '../../series/SeriesScreen.dart';

class FixturesTeamsScreen extends StatefulWidget{
  const FixturesTeamsScreen({super.key});
  @override
  State<StatefulWidget> createState() => FixturesTeamsScreenState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
ScrollController _scrollController = ScrollController();
bool _isLoadingMore = false;

class FixturesTeamsScreenState extends State<FixturesTeamsScreen>{

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if(Provider.of<HomeController>(context, listen: false).teamListData.isEmpty){
        Provider.of<HomeController>(context, listen: false).loadingTeamList = true;
        Provider.of<HomeController>(context, listen: false).getTeamsList(context);
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  Future<void> _loadMoreData() async {
    // setState(() {
    //   _isLoadingMore = true;
    // });

    // await Provider.of<HomeController>(context, listen: false).getSeriesForFixturesList(context);

    // setState(() {
    //   _isLoadingMore = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, myData, _){
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
    HomeController provider = Provider.of(context, listen: false);
    return provider.loadingTeamList
        ? const Center(child: CircularProgressIndicator())
        : provider.teamListData.isEmpty
        ? Center(child: emptyWidget(context))
        : ListView.builder(
      // controller: _scrollController,
      itemCount: provider.teamListData.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.teamListData.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return matchCard();
      },
    );
  }




  Widget matchCard(){
    HomeController provider = Provider.of(context, listen: false);
    double teamWidth = 40;
    return Column(
      children: [
        ...provider.teamListData.map((e) {
          return InkWell(
            onTap: (){
              provider.teamDetailBottomSheet(context, e["team_id"].toString(), e["name"]);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(teamWidth/2),
                    child: CachedNetworkImage(
                      imageUrl: e["flag"] ??
                          'https://www.google.com.au/image_url.png',
                      imageBuilder: (context, imageProvider) =>
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
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: teamWidth,
                          width: teamWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset(
                            "assets/images/logo.png",
                            height: teamWidth,
                            width: teamWidth,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-130,
                    child: Text(e["name"] ?? "----", style: Theme.of(context).textTheme.titleMedium?.copyWith(), overflow: TextOverflow.ellipsis,),
                  ),
                  Icon(Icons.navigate_next, size: 20, color: Theme.of(context).hintColor,)
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}