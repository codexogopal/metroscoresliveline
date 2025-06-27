import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/HomeController.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../../utils/AppBars.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';
import '../../match_detail/MatchDetailsScreen.dart';

class HomeFinishedNew extends StatefulWidget {
  const HomeFinishedNew({super.key});
  @override
  State<StatefulWidget> createState() => HomeFinishedNewState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeFinishedNewState extends State<HomeFinishedNew> {
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _page = 0;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Provider.of<HomeController>(context, listen: false).getFinishedMatchesList(context);
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
    await Provider.of<HomeController>(context, listen: false).getFinishedMatchesList(context);

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    // provider.finishedMListLoading = true;
    return Consumer<HomeController>(builder: (context, myData, _) {
      return Scaffold(
        appBar: AppBars.myAppBar("Finished Matches", context, true),
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
    return provider.finishedMListLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.finishedMatchesList.isEmpty
        ? emptyWidget(context)
        : ListView.builder(
      controller: _scrollController,
      itemCount: provider.finishedMatchesList.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.finishedMatchesList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return matchItem(context, provider.finishedMatchesList[index], true, "2", false);
      },
    );
  }
}