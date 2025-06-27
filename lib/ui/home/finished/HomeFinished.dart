
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../commonUi/CommonUi.dart';

class HomeFinished extends StatefulWidget{
  const HomeFinished({super.key});
  @override
  State<StatefulWidget> createState() => HomeFinishedState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeFinishedState extends State<HomeFinished>{

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      Provider.of<HomeController>(context, listen: false).getFinishedMatchesList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<HomeController>(context, listen: false).finishedMListLoading = true;
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

  Widget addBody(){
    double teamWidth = 35;
    HomeController provider = Provider.of(context, listen: false);
    return provider.finishedMListLoading ? const Center(child: CircularProgressIndicator(),) : SizedBox(
      child: provider.finishedMatchesList.isEmpty ? const Center(child: Text("No Data Found")) : ListView(
        children: [
          matchDateWiseFilter(context, provider.finishedMatchesList),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }


}