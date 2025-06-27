import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/common_color.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class DayFixturesScreen extends StatefulWidget {
  const DayFixturesScreen({super.key});

  @override
  State<StatefulWidget> createState() => DayFixturesScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class DayFixturesScreenState extends State<DayFixturesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (Provider.of<HomeController>(context, listen: false)
          .fixturesDayListLoading) {
        Provider.of<HomeController>(context, listen: false)
            .getFixturesDayMatchesList(context);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Provider.of<HomeController>(context, listen: false)
        .getFixturesDayMatchesList(context);
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeController provider = Provider.of(context, listen: false);
    return Consumer<HomeController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: provider.match.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                          provider.selectedIndex = index;
                          provider.onTabChange(index);
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: provider.selectedIndex == index ? Color(CommonColor.blueColor) : Theme.of(context).colorScheme.secondaryContainer,
                          border: Border.all(color: provider.selectedIndex == index ? Color(CommonColor.blueColor) : myprimarycolor)
                        ),
                        child: Center(
                          child: Text(
                            provider.match[index],
                            style: mItemTextStyle(context)?.copyWith(fontWeight: FontWeight.w700,
                              fontFamily: "b",
                              color: provider.selectedIndex == index ? Colors.white : null,),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Another Expanded widget to take up remaining space
              Expanded(
                child: addBody(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget addBody() {
    HomeController provider = Provider.of(context, listen: false);
    return provider.fixturesDayListLoading
        ? const Center(child: CircularProgressIndicator())
        : provider.fixturesDayMatchesList.isEmpty
            ? Center(child: emptyWidget(context))
            : ListView.builder(
                // controller: _scrollController,
                itemCount: provider.fixturesDayMatchesList.length +
                    (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == provider.fixturesDayMatchesList.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return matchItem(context,
                      provider.fixturesDayMatchesList[index], false, "1", false);
                },
              );
  }
}
