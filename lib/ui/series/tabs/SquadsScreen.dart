import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../../../controllers/SeriesController.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';
import '../CommonFiles/SquadsDetailScreen.dart';

class SquadsScreen extends StatefulWidget {
  const SquadsScreen({super.key});

  @override
  State<StatefulWidget> createState() => SquadsScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
Map selectedSeriesData = {};
bool haveSquadsReload = false;
List<Widget> listBottomWidget = [];

class SquadsScreenState extends State<SquadsScreen> {
  @override
  void initState() {
    selectedSeriesData = Provider.of<SeriesController>(context, listen: false).selectedSeriesData;
    haveSquadsReload = Provider.of<SeriesController>(context, listen: false).haveSquadsReload;
    Map<String, String> fixturesDate = {
      "series_id": selectedSeriesData["series_id"].toString()
    };
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if(haveSquadsReload){
        Provider.of<SeriesController>(context, listen: false)
            .getSquadsListMatchesList(context, fixturesDate);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    provider.haveSquadsReload ? provider.squadsLoading = true : provider.squadsLoading = false;
    return Consumer<SeriesController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child:mContainer(
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

  Widget addBody() {
    double teamWidth = 45;
    SeriesController provider = Provider.of(context, listen: false);
    return  SizedBox(
      child: provider.squadsLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.squadsList.isEmpty
          ? emptyWidget(context)
          : ListView(
              children: [
                Column(
                  children: [
                    ...provider.squadsList.map((e) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: (){
                              // squadsDetailBottomSheet(context, e);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  SquadsDetailScreen(squadsData: e)));
                            },
                            child: mView(e["team"]["name"] , e["team"]["flag"]),
                          ),
                          hrLightWidget(context),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
  Widget mView(String title, String value){
    double teamWidth = 45;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          mBoxShadow(context)
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                    imageUrl: value ??
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
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(),
              ),
            ],
          ),
          const Icon(
            Icons.navigate_next,
            size: 20,
            color: Colors.black38,
          )
        ],
      ),
    );
  }

  final controller = SheetController();
  void squadsDetailBottomSheet(BuildContext context, Map data) async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          duration: const Duration(milliseconds: 200),
          controller: controller,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) => SquadsDetailScreen(squadsData: data)
      );
    });

    // print(result); // This is the result.
  }

}
