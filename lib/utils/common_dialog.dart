import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/mythemcolor.dart';

class CommanDialog {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static showLoading(BuildContext context, {String title = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(myprimarycolor),
            ),
          ),
        );
      },
    );
  }

  static hideLoading() {
    if (kDebugMode) {
      print("Hiding loading dialog");
    } // Debug print
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    } else {
      if (kDebugMode) {
        print("Cannot pop the navigator");
      } // Debug print
    }
  }

  static showMyLoading(context, bool showOrHide) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        );
      },
    );
  }

  static refereshScreen(context, {String title = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.black),
          ),
        );
      },
    );
  }



  static showErrorDialog(
    context, {
    String title = "Oops Error",
    String description = "Something went wrong ",
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            height: 100,
            child: Column(children: [
              Text(description),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ]),
          ),
        );
      },
    );
  }

  static showExitDialog(
    context, {
    String title = "Oops Error",
    String description = "Confirm Exit?",
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10.0, 20, 0.0, 0.0),
                    child: Text(description,style: const TextStyle(fontFamily: 'ssb',color: Colors.black,fontSize: 20),textAlign: TextAlign.start),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 0.0, 0.0),
                    child: const Text('Are you sure you want to exit app?',style: TextStyle(fontFamily: 'ssr',color: Colors.black,fontSize: 16),textAlign: TextAlign.start),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        // Future.value(true);
                        Navigator.pop(context, true);
                      },
                      child: Text("YES",style: TextStyle(fontFamily: 'ssr',color: Theme.of(context).primaryColor,fontSize: 18))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("NO",style: TextStyle(fontFamily: 'ssr',color: Colors.black,fontSize: 18))),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
