import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/SeriesController.dart';
import '../../../theme/mythemcolor.dart';
import '../../../utils/styleUtil.dart';
import '../../commonUi/CommonUi.dart';

class PointsTableScreen extends StatefulWidget {
  final String seriesId;
  const PointsTableScreen({super.key, required this.seriesId});

  @override
  State<StatefulWidget> createState() => PointsTableScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
Map selectedSeriesData = {};
bool havePointsTableReload = false;
List<Widget> listBottomWidget = [];

class PointsTableScreenState extends State<PointsTableScreen> {
  @override
  void initState() {
    selectedSeriesData = Provider.of<SeriesController>(context, listen: false).selectedSeriesData;
    havePointsTableReload = Provider.of<SeriesController>(context, listen: false).havePointsTableReload;
    Map<String, String> fixturesDate = {
      "series_id": widget.seriesId
    };
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      // if(havePointsTableReload){
        Provider.of<SeriesController>(context, listen: false)
            .getPointsTableList(context, fixturesDate);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeriesController provider = Provider.of(context, listen: false);
    provider.havePointsTableReload ? provider.pointsLoading = true : provider.pointsLoading = false;
    // provider.pointsLoading = true;
    return Consumer<SeriesController>(builder: (context, myData, _) {
      return Scaffold(
        body: SafeArea(
          child: mContainer(
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
    double teamWidth = 20;
    SeriesController provider = Provider.of(context, listen: false);
    return provider.pointsLoading ? const Center(child: CircularProgressIndicator(),) : SizedBox(
      child: provider.pointsTableList.isEmpty
          ? emptyWidget(context)
          : ListView(
        children: [
          const SizedBox(
            height: 0,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                          child: Text("Team", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("P", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("W", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("L", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("NR", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("Pts", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("NRR", style: Theme.of(context).textTheme.titleLarge?.copyWith(),)
                      ),
                    ],
                  ),
                ),
                ...provider.pointsTableList.map((e) {
                  return Column(
                    children: [
                      hrLightWidget(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: e["flag"] ??'https://www.google.com.au/image_url.png',
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
                                    const SizedBox(width: 8,),
                                    Text(e["teams"], style: Theme.of(context).textTheme.titleMedium,),
                                  ],
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["P"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["W"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["L"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["NR"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["Pts"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(e["NRR"].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                Visibility(visible: false,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Calculate the width of each column
                      double columnWidth = constraints.maxWidth / 7;
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: myprimarycolor.shade50, // Set divider color
                          dividerTheme: const DividerThemeData(
                            thickness: 2.0, // Set divider thickness
                          ),
                        ),
                        child: DataTable(
                          columnSpacing: columnWidth/2.5,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Team'),
                            ),
                            DataColumn(
                              label: Text('P'),
                            ),
                            DataColumn(
                              label: Text('W'),
                            ),
                            DataColumn(
                              label: Text('L'),
                            ),
                            DataColumn(
                              label: Text('NR'),
                            ),
                            DataColumn(
                              label: Text('Pts'),
                            ),
                            DataColumn(
                              label: Text('NRR'),
                            ),
                          ],
                          rows: [
                            ...provider.pointsTableList.map((e) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Container(
                                    color: Colors.grey,
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: e["flag"] ??'https://www.google.com.au/image_url.png',
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
                                        const SizedBox(width: 8,),
                                        Text(e["teams"], style: Theme.of(context).textTheme.titleMedium,),
                                      ],
                                    ),
                                  )),
                                  DataCell(Text(e["P"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                  DataCell(Text(e["W"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                  DataCell(Text(e["L"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                  DataCell(Text(e["NR"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                  DataCell(Text(e["Pts"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                  DataCell(Text(e["NRR"], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),)),
                                ],
                              );
                            }),
                          ],
                          /*rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Row 1, Column 1')),
                                DataCell(Text('Row 1, Column 2')),
                                DataCell(Text('Row 1, Column 3')),
                                DataCell(Text('Row 1, Column 4')),
                                DataCell(Text('Row 1, Column 5')),
                                DataCell(Text('Row 1, Column 6')),
                                DataCell(Text('Row 1, Column 7')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Row 2, Column 1')),
                                DataCell(Text('Row 2, Column 2')),
                                DataCell(Text('Row 2, Column 3')),
                                DataCell(Text('Row 2, Column 4')),
                                DataCell(Text('Row 2, Column 5')),
                                DataCell(Text('Row 2, Column 6')),
                                DataCell(Text('Row 2, Column 7')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Row 3, Column 1')),
                                DataCell(Text('Row 3, Column 2')),
                                DataCell(Text('Row 3, Column 3')),
                                DataCell(Text('Row 3, Column 4')),
                                DataCell(Text('Row 3, Column 5')),
                                DataCell(Text('Row 3, Column 6')),
                                DataCell(Text('Row 3, Column 7')),
                              ],
                            ),
                          ],*/
                        ),
                      );
                    },
                  ),
                ),
                ...provider.pointsTableList.map((e) {
                  return Column(
                    children: [
                      hrLightWidget(context),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
