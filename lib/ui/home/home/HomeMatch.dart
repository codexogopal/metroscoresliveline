
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../theme/mythemcolor.dart';
import '../../commonUi/CommonUi.dart';

class HomeMatch extends StatefulWidget{
  const HomeMatch({super.key});
  @override
  State<StatefulWidget> createState() => HomeMatchState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
ScrollController _scrollController = ScrollController();
bool _isLoadingMore = false;

class HomeMatchState extends State<HomeMatch>{

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      Provider.of<HomeController>(context, listen: false).getLiveMatchList(context);
    });
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<HomeController>(context, listen: false).getHomeList(context);
    });
   /* _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
        _loadMoreData();
      }
    });*/
    super.initState();
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Provider.of<HomeController>(context, listen: false).getHomeList(context);

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeController>(context, listen: false).homeMatch = true;
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
    return provider.homeMatch
        ? const Center(child: CircularProgressIndicator())
        : provider.homeDataFilter.isEmpty
        ? emptyWidget(context)
        : ListView.builder(
      controller: _scrollController,
      itemCount: provider.homeDataFilter.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.homeDataFilter.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return matchItem(context, provider.homeDataFilter[index], false, "2", true);
      },
    );
  }
}