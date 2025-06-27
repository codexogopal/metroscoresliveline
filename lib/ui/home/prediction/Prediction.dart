
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../controllers/HomeController.dart';
import '../../../controllers/MatchDetailController.dart';
import '../../commonUi/CommonUi.dart';
import '../../match_detail/MatchDetailsScreen.dart';

class Prediction extends StatefulWidget{
  const Prediction({super.key});
  @override
  State<StatefulWidget> createState() => PredictionState();
}
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class PredictionState extends State<Prediction>{

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      Provider.of<HomeController>(context, listen: false).getPrediction(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<HomeController>(context, listen: false).isPredict = false;
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
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    HomeController provider = Provider.of(context, listen: false);
    return provider.isPredict ? const Center(child: CircularProgressIndicator(),) : SizedBox(
      child: provider.predictionList.isEmpty ? emptyWidget(context) : ListView(
        children: [
          ...provider.predictionList.map((e) {
            return Column(
              children: [
                InkWell(
                  onTap: (){
                    openWhatsApp(e["value"]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        boxShadow: [BoxShadow(
                          color: isDarkTheme ? Colors.black54 : Colors.grey.shade300,
                          offset: const Offset(0, 2),
                          blurRadius: 1.0,
                        ),]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(e["title"], style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
                          ],
                        ),
                        Icon(Icons.navigate_next, color: Theme.of(context).hintColor,size: 25,)
                      ],
                    ),
                  ),
                ),

              ],
            );
          }),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }


}