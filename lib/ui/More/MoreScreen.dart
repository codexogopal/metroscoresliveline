import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constant.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/LiveMatchControllers.dart';
import '../../controllers/MyTransactionController.dart';
import '../../session/SessionManager.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../commonUi/CommonUi.dart';
import 'AboutPageScreen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<StatefulWidget> createState() => MoreScreenState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
int selectedPosition = 0;
List<Widget> listBottomWidget = [];

class MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      // Provider.of<MyTransactionController>(context, listen: false).getSocialData(context);
  });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    MyTransactionController provider = Provider.of(context, listen: false);
    LiveMatchController liveMatchController = Provider.of(context, listen: false);
    liveMatchController.stopFetchingMatchInfo();
    return Consumer<MyTransactionController>(builder: (context, myData, _) {
      return Scaffold(
        appBar: AppBars.myAppBar("More", context, false),
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
    MyTransactionController provider = Provider.of(context, listen: false);
    return ListView(
          children: [
            viewWith(),
            /*if(provider.socialData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text("Visit", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
            ),
            if(provider.socialData.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.primaryContainer
              ),
              child: Column(
                children: [
                  InkWell(onTap: (){openWhatsApp(provider.socialData[0]["value"]);},child: viewWith3("Facebook", "assets/images/facebook-logo.png")),
                  // hrLightWidget(context),
                  // InkWell(onTap: (){openWhatsApp(provider.socialData["telegram_link"]);},child: viewWith3("Telegram", "assets/images/telegram.png")),
                  hrLightWidget(context),
                  InkWell(onTap: (){openWhatsApp(provider.socialData[1]["value"]);},child: viewWith3("Instagram", "assets/images/instagram.png")),
                  // hrLightWidget(context),
                  // InkWell(onTap: (){openWhatsApp(provider.socialData["whatapp_link"]);},child: viewWith3("Whatsapp", "assets/images/whatsapp.png")),
                ],
              ),
            ),
*/
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text("Support", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.primaryContainer
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      openWhatsApp(Platform.isAndroid ? Constant.PLAY_STORE_LINK : Constant.APP_STORE_LINK);
                    },
                      child: viewWith3("Rats Us", "assets/images/star.png")),
                  hrLightWidget(context),
                  InkWell(onTap: () async {
                    String email = Uri.encodeComponent(Constant.CONTACT_US_EMAIL);
                    Uri mail = Uri.parse("mailto:$email");
                    if (await launchUrl(mail)) {
                    //email app opened
                    }else{
                    //email app is not opened
                    }
                    // openWhatsApp(emailLaunchUri.toString());
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsScreen()));
                  },child: viewWith3("Contact Us", "assets/images/contact-us.png")),
                  hrLightWidget(context),
                  InkWell(
                      onTap: (){
                        openWhatsApp(Platform.isAndroid ? Constant.PLAY_STORE_LINK : Constant.APP_STORE_LINK);
                      },child: viewWith3("Check for Updates", "assets/images/check-for-update.png")),
                  hrLightWidget(context),
                  InkWell(onTap: () async {
                    String email = Uri.encodeComponent(Constant.CONTACT_US_EMAIL);
                    Uri mail = Uri.parse("mailto:$email");
                    if (await launchUrl(mail)) {
                    //email app opened
                    }else{
                    //email app is not opened
                    }
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsScreen()));
                  },child: viewWith3("Report a Problem", "assets/images/warning.png")),
                  hrLightWidget(context),
                  InkWell(onTap: (){
                    onInviteFriends();
                  },child: viewWith3("Invite Friends", "assets/images/share.png")),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text("About", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.primaryContainer
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPageScreen(textData: Constant.ABOUT_US, title: "About Us")));
                    },
                      child: viewWith3("About Us", null)
                  ),
                  hrLightWidget(context),
                  InkWell(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPageScreen(textData: Constant.TERMS, title: "Terms and Conditions")));
                        openWhatsApp(Constant.termsCondition);
                      },child: viewWith3("Terms and Conditions", null)),
                  hrLightWidget(context),
                  InkWell(
                      onTap: (){
                        openWhatsApp(Constant.privacyPolicy);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPageScreen(textData: Constant.PRIVACY_POLICY, title: "Privacy Policy")));
                      },child: viewWith3("Privacy Policy", null)),
                ],
              ),
            ),

            if(SessionManager.isLogin()!)
            InkWell(
              onTap: (){
                logoutDialogNew(context);
              },
                child: viewWith2("Logout")
            ),
            const SizedBox(height: 10,),
          ],
        );
  }

  Widget viewWith2(String title){
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primaryContainer
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
          Icon(Icons.navigate_next, color: Theme.of(context).hintColor,size: 25,)
        ],
      ),
    );
  }

  Widget viewWith(){
    HomeController provider = Provider.of(context, listen: false);
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return  Container(
      padding: const EdgeInsets.fromLTRB(15, 05, 10, 05),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 2.0,
              offset: Offset(0.0, 0.0)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Light/Dark",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(),
          ),
          Switch(
            activeColor: Colors.blue,
            value: SessionManager.isAppDarkTheme() == null ? isDarkTheme :
            SessionManager.isAppDarkTheme() == true ? true :
            false,
            onChanged: (value) {
              setState(() {
                provider.isDarkMode = value;
              });
              ThemeMode newThemeMode = provider.isDarkMode ? ThemeMode.dark : ThemeMode.light;
              provider.changeTheme(newThemeMode);
            },
          ),
        ],
      ),
    );
  }

  Widget viewWith3(String title, String? image){
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 2.0,
              offset: Offset(0.0, 0.0)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(image != null)
              Image.asset(image, height: 20,color: Theme.of(context).hintColor,),
              if(image != null)
              const SizedBox(width: 15,),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(),),
            ],
          ),
          Icon(Icons.navigate_next, color: Theme.of(context).hintColor,size: 25,)
        ],
      ),
    );
  }

  Future<bool?> logoutDialogNew(context){
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text('Do you really want to Logout!',style: TextStyle(
                color: Colors.black
            ),),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',
                  style: TextStyle(color: myprimarycolor, fontFamily: 'sb', fontSize: 16),),
              ),
              TextButton(
                onPressed: () {
                  SessionManager().logout(context);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('Logout',
                  style: TextStyle(color: myprimarycolor, fontFamily: 'sb', fontSize: 16),),
              ),
            ],
          );
        }
    );
  }
}
