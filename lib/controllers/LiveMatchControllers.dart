
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gif/gif.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../Constant.dart';
import '../utils/common_dialog.dart';
import '../utils/styleUtil.dart';
import "package:http/http.dart" as http;

class LiveMatchController extends ChangeNotifier {

  final FlutterTts flutterTts = FlutterTts();
  bool isVoiceMute = true;
  Map liveMatchData = {};
  bool isLoadingFirstTime = true;
  Timer? _timer;

  // Method to start the periodic call
  void startLiveMatchInfo(context, String matchId) {

   _timer == null ? _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (kDebugMode) {
        print("11111111111111");
      }
      getLiveData(context, matchId);
    }) : null;
  }

  // Method to stop the periodic call
  void stopFetchingMatchInfo() {
    if (_timer != null) {
      if (kDebugMode) {
        print("cancleeeeee");
      }
      _timer!.cancel();
      _timer = null;
    }
  }

  Future<void> getLiveData(context, String matchId) async {
    var request = http.MultipartRequest('POST', Uri.parse(Constant.liveMatchData));
    request.fields.addAll({
      "match_id" :matchId.toString()
    });
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        notifyListeners();
        if (data['status'] == true) {
          // showToast("msg");
          liveMatchData = data["data"];
            textToSpeech(liveMatchData["first_circle"].toString());
          Timer(const Duration(milliseconds: 50), () {
            isLoadingFirstTime = false;
            notifyListeners();
          });

        } else {
          // showToast(data['msg']);
          notifyListeners();
        }
      } else {
          notifyListeners();
      }
    } catch (error) {
        notifyListeners();
      print("Error $error");
    }
  }



  void isMuteVoice(bool muteStatus){
    isVoiceMute = muteStatus;
    notifyListeners();
  }

  Future<void> textToSpeech(String lastballTitle) async {
    String lastballSpeech;

    switch (lastballTitle) {
      case 'dot':
      case '0':
        lastballSpeech = 'khali ball khali ball';
        break;
      case '1':
        lastballSpeech = 'Single aya single aya';
        break;
      case '2':
        lastballSpeech = 'Double aya Double aya';
        break;
      case '3':
        lastballSpeech = 'Triple aya Triple aya';
        break;
      case '6':
      case 'six':
      case 'Six':
        lastballSpeech = 'Six aya Six aya';
        break;
      case '4':
      case 'Four':
      case 'four':
        lastballSpeech = 'Chouka aya Chouka aya';
        break;
      case 'Wide':
      case 'wide':
      case '1wd':
        lastballSpeech = 'wide aya wide aya';
        break;
      case 'Over':
      case 'over':
        lastballSpeech = 'Over Complete';
        break;
      case 'Wicket':
        lastballSpeech = 'Wicket gaya';
        break;
      default:
        lastballSpeech = lastballTitle;
        break;
    }
    // List<dynamic> languages = await flutterTts.getLanguages;
    // print("languages ${languages}");
    flutterTts.setLanguage("en-IN");
    flutterTts.setSpeechRate(0.5);
    // print("in if 0 $lastballTitle  ${Constant.lastBallGetStatus}");
    if(Constant.lastBallGetStatus != lastballTitle) {
      // print("in if 1 $lastballTitle  ${Constant.lastBallGetStatus}");
      if(!isVoiceMute) {
        // print("in if 2 $lastballTitle  ${Constant.lastBallGetStatus}");
        await flutterTts.speak(lastballSpeech);
      }
      Constant.lastBallGetStatus = lastballTitle;
    }
  }

  Widget liveFirstCircle(BuildContext context, String ball) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (ball == "Six" || ball == "six" || ball == "6") ?
        gifItem("assets/images/six.gif", ball) :
        (ball == "Four" || ball == "four" || ball == "4") ?
        gifItem("assets/images/fourgif.gif", ball) :
        (ball == "Wicket" || ball == "wicket") ?
        gifItem("assets/images/wicket.gif", ball) :
        (ball == "Ball" || ball == "ball") ?
        gifItem("assets/images/ball.gif", ball) :
        (ball == "Wide" || ball == "wide" || ball == "1wd") ?
        gifItem("assets/images/wide_ball.gif", ball) :
        (ball == "No Ball" || ball == "no ball") ?
        gifItem("assets/images/no-ball.gif", ball) :
        Text(
          ball ?? "",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0XFFe6f6c7),
              fontFamily: "sb",
              fontSize: 18),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget gifItem(String gPath, String ball){
    return Gif(
      autostart: Autostart.loop,
      placeholder: (context) => Text(
        ball ?? "",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: "sb",
            fontSize: 18),
        textAlign: TextAlign.center,
      ),
      image: AssetImage(gPath),
    );
  }
}