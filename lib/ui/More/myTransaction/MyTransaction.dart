import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/MyTransactionController.dart';
import '../../../utils/AppBars.dart';
import '../../commonUi/CommonUi.dart';
import '../../news/NewsDetailScreen.dart';


class MyTransaction extends StatefulWidget {
  const MyTransaction({super.key});

  @override
  State<StatefulWidget> createState() => MyTransactionState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class MyTransactionState extends State<MyTransaction> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<MyTransactionController>(context, listen: false).getMyTransactionList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    MyTransactionController provider = Provider.of(context, listen: false);
    return Consumer<MyTransactionController>(builder: (context, myData, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBars.myAppBar("My Transaction", context, true),
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
    double myWidth = MediaQuery.of(context).size.width-30;
    double myHeight = 150;
    MyTransactionController provider = Provider.of(context, listen: false);
    return SizedBox(
      child: provider.myTransactionData.isEmpty
          ? Center(child: emptyWidget(context))
          : ListView(
        children: [
          ...provider.myTransactionData.map((e) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(newsData: e)));
              },
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer),
                    child: Column(
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 itemRow("S.NO. ", e["s_no"].toString()),
                                 itemRow("Date : ", e["date"].toString()),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              itemRow("Transaction Id : ", e["transaction_id"]),
                              const SizedBox(height: 10,),
                              itemRow("Plan : ", e["plan_type"]),
                              const SizedBox(height: 10,),
                              itemRow("Status : ", e["transaction_status"]),
                              const SizedBox(height: 10,),
                              itemRow("Remark : ", e["remark"]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 15,)
        ],
      ),
    );
  }
  Widget itemRow(String title, String value){
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: value == "Pending" ? Colors.yellow.shade700 :
          value == "Success" ? Colors.green.shade700 :
          (value == "Failed" || value == "Rejected") ? Colors.red.shade500 :
          Theme.of(context).hintColor),
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
