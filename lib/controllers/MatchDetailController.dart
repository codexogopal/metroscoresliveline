import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../Constant.dart';
import '../session/SessionManager.dart';
import '../ui/match_detail/info/PlayIngXIScreen.dart';
import '../utils/common_dialog.dart';
import '../utils/styleUtil.dart';
import "package:http/http.dart" as http;

class MatchDetailController extends ChangeNotifier {

  Map matchInfo = {};
  Map matchListObjectInfo = {};
  bool isLoadingInfo = true;

  Future<void> getMatchInfoById(context, Map<String, String> seriesId) async {
    isLoadingInfo = true;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.matchInfo));
    request.fields.addAll(seriesId);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        matchInfo = {};
        notifyListeners();
        if (data['status'] == true) {
          matchInfo = data["data"];
          Timer(const Duration(milliseconds: 100), () {
            isLoadingInfo = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingInfo = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingInfo = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingInfo = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }


  Map teamAData = {};
  Map teamBData = {};
  Map teamData = {};
  String loadedMatchId = "";
  bool isLoadingPlayer = true;

  Future<void> getPlayingXiByMatchId(context, String matchId,
      String dataForTeam) async {
    isLoadingPlayer = true;
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.playingXiByMatchId));
    request.fields.addAll(
        {
          "match_id": matchId
        }
    );
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        teamAData = {};
        teamBData = {};
        notifyListeners();
        if (data['status'] == true) {
          loadedMatchId = matchId;
          teamAData = data["data"]["team_a"];
          teamBData = data["data"]["team_b"];
          if (dataForTeam == "team_a") {
            teamData = teamAData;
          } else {
            teamData = teamBData;
          }
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlayer = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          loadedMatchId = "";
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlayer = false;
            notifyListeners();
          });
        }
      } else {
        loadedMatchId = "";
        Timer(const Duration(milliseconds: 100), () {
          isLoadingPlayer = false;
          notifyListeners();
        });
      }
    } catch (error) {
      loadedMatchId = "";
      Timer(const Duration(milliseconds: 100), () {
        isLoadingPlayer = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  void loadPlayerData(String clickedFrom) {
    if (clickedFrom == "team_a") {
      teamData = teamAData;
    } else {
      teamData = teamBData;
    }
  }

  void squadsDetailBottomSheet(BuildContext context, String matchId,
      String clickedFrom) async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          duration: const Duration(milliseconds: 200),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) =>
              PlayIngXIScreen(matchId: matchId, clickedFrom: clickedFrom)
      );
    });

    // print(result); // This is the result.
  }

  /******************************************************************************************************************************************************************/


  bool isLoadingOdds = true;
  List oddsDataList = [];
  List odds1stInningDataList = [];
  List odds2stInningDataList = [];
  List listForShowOddsData = [];

  Future<void> getOddsHistory(context, Map<String, String> seriesId) async {
    isLoadingOdds = true;
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.matchOddHistory));
    request.fields.addAll(seriesId);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        oddsDataList = [];
        odds1stInningDataList = [];
        odds2stInningDataList = [];
        notifyListeners();
        if (data['status'] == true) {
          oddsDataList = data["data"];
          for (int i = 0; i < oddsDataList.length; i++) {
            if (oddsDataList[i]["inning"] == 1) {
              odds1stInningDataList.add(oddsDataList[i]);
            } else {
              odds2stInningDataList.add(oddsDataList[i]);
            }
          }
          Timer(const Duration(milliseconds: 100), () {
            isLoadingOdds = false;
            switchOddsData(selectedInning);
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingOdds = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingOdds = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingOdds = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  int selectedInning = 1;

  void switchOddsData(int clickedBtn) {
    Timer(const Duration(milliseconds: 100), () {
      if (clickedBtn == 1) {
        listForShowOddsData = odds1stInningDataList;
        selectedInning = clickedBtn;
      } else {
        listForShowOddsData = odds2stInningDataList;
        selectedInning = clickedBtn;
      }
      print(listForShowOddsData.toString());
      notifyListeners();
    });
  }


  /******************************************************************************************************************************************************************/


  bool isLoadingCommentary = true;
  List<dynamic> commentaryData = [];

  Future<void> getCommentary(context, Map<String, String> matchID) async {
    isLoadingCommentary = true;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.commentary));
    request.fields.addAll(matchID);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        commentaryData = [];
        notifyListeners();
        if (data['status'] == true) {
          // commentaryData = data['data'];

          data['data'].forEach((key, value) {
            value.forEach((subKey, matches) {
              for (var match in matches) {
                commentaryData.add(match);
              }
            });
          });
          Timer(const Duration(milliseconds: 100), () {
            isLoadingCommentary = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingCommentary = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingCommentary = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingCommentary = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  /******************************************************************************************************************************************************************/


  bool isLoadingScoreCard = true;
  Map scorecardData = {};
  Map scorecardTeam1Data = {};
  Map scorecardTeam2Data = {};
  int selectedSTeam = 1;

  Future<void> getScorecardData(context, Map<String, String> matchID) async {
    isLoadingScoreCard = true;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.scorecardByMatchId));
    request.fields.addAll(matchID);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        scorecardData = {};
        scorecardTeam1Data = {};
        scorecardTeam2Data = {};
        notifyListeners();
        if (data['status'] == true) {
          if(data["data"]["scorecard"].containsKey("1")){
            scorecardTeam1Data = data["data"]["scorecard"]["1"];
          }
          if(data["data"]["scorecard"].containsKey("2")){
            scorecardTeam2Data = data["data"]["scorecard"]["2"];
          }
          Timer(const Duration(milliseconds: 100), () {
            isLoadingScoreCard = false;
            switchScorecard(selectedSTeam);
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingScoreCard = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingScoreCard = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingScoreCard = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  void switchScorecard(int clicked){
    if(clicked == 1){
      scorecardData = scorecardTeam1Data;
      selectedSTeam = 1;
    }else{
      scorecardData = scorecardTeam2Data;
      selectedSTeam = 2;
    }
    notifyListeners();
  }

  /******************************************************************************************************************************************************************/


  bool isLoadingFancy = true;
  List fancyDataList = [];
  Future<void> getFancyData(context, Map<String, String> matchID) async {
    isLoadingFancy = true;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.matchFancy));
    request.fields.addAll(matchID);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        notifyListeners();
        if (data['status'] == true) {
          fancyDataList = data["data"];
          Timer(const Duration(milliseconds: 100), () {
            isLoadingFancy = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingFancy = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingFancy = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingFancy = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }



  /******************************************************************** checkPrediction API *********************************************************************************/
  Map<String, String> matchData = {};
  bool isAnyPlanAvailable = false;
  bool isLoadingPrediction = false;
  Future<void> checkPrediction(context) async {
    isAnyPlanAvailable = false;
    isLoadingPrediction = true;
    notifyListeners();
    var request = http.MultipartRequest('POST', Uri.parse(Constant.checkPrediction));
    request.fields.addAll(getRequestForPrediction());
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response11 $isAnyPlanAvailable  $data");
        }
        if (data['status'] == true) {
          isAnyPlanAvailable = true;
          if (kDebugMode) {
            print("response12 $isAnyPlanAvailable  $data");
          }
          getPredictionData(context);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPrediction = false;
            notifyListeners();
          });
          Timer(const Duration(milliseconds: 1000), () {
            notifyListeners();
          });
        } else {
          // showToast(data['message']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPrediction = false;
            isAnyPlanAvailable = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingPrediction = false;
          isAnyPlanAvailable = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingPrediction = false;
        isAnyPlanAvailable = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  Map matchPredictionData = {};
  Future<void> getPredictionData(context) async {
    isLoadingPrediction = true;
    matchPredictionData = {};
    notifyListeners();
    var request = http.MultipartRequest('POST', Uri.parse(Constant.predictionData));
    request.fields.addAll(
      {
        "match_api_id" : matchListObjectInfo["match_id"].toString()
      }
    );
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response12  $data");
        }
        if (data['status'] == true) {
          matchPredictionData = data["data"];
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPrediction = false;
            notifyListeners();
          });
          Timer(const Duration(milliseconds: 1000), () {
            notifyListeners();
          });
        } else {
          // showToast(data['message']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPrediction = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingPrediction = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingPrediction = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  Map<String, String> getRequestForPrediction(){
    String status = matchListObjectInfo["match_status"] == "Upcoming" ? "1" :
    matchListObjectInfo["match_status"] == "Live" ? "2" :
    matchListObjectInfo["match_status"] == "Finished" ? "3" : matchListObjectInfo["match_status"].toString();
    matchData = {
      "user_id" : SessionManager.getUserId().toString(),
      "match_api_id" : matchListObjectInfo["match_id"].toString(),
      "series_api_id" : matchListObjectInfo["series_id"].toString(),
      "match_status" : status,
    };
    if (kDebugMode) {
      print("matchData $matchData\n\n$matchListObjectInfo");
    }
    return matchData;
  }

  /******************************************************************** checkPrediction API *********************************************************************************/


  bool isLoadingPlanList = true;
  Map plans = {};
  Map content = {};
  List plansList = [];
  Future<void> getPlanList(context) async {
    isLoadingPlanList = true;
    var request = http.MultipartRequest('GET', Uri.parse(Constant.planList));
    // request.fields.addAll(matchData);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        plans = {};
        content = {};
        plansList = [];
        notifyListeners();
        if (data['status'] == true) {
          plans = data["data"]["plan"];
          content = data["content"];
          plansList = [
            {
              "amount" : plans["silver"],
              "title" : "Silver Plan",
              "plan": "1 Match",
              "content": content["silver"] ?? [],
              "index": 1,
            },
            {
              "amount" : plans["gold"],
              "title" : "Gold Plan",
              "plan": "One Month",
              "content": content["gold"] ?? [],
              "index": 2,
            },
            {
              "amount" : plans["diamond"],
              "title" : "Diamond Plan",
              "plan": "One Year",
              "content": content["diamond"] ?? [],
              "index": 3,
            },
          ];
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlanList = false;
            notifyListeners();
          });
        } else {
          // showToast(data['message']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlanList = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingPlanList = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingPlanList = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }


  Map upiData = {};
  Future<void> getBuyAPlanUpiData(context) async {
    CommanDialog.showLoading(context);
    var request = http.MultipartRequest('GET', Uri.parse(Constant.UPI_API));
    // request.fields.addAll(matchData);
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        upiData = {};
        notifyListeners();
        if (data['status'] == true) {
          upiData = data["data"];

          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            notifyListeners();
          });
        } else {
          // showToast(data['message']);
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            notifyListeners();
          });
        }
      } else {
        CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100), () {
          notifyListeners();
        });
      }
    } catch (error) {
      CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100), () {
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }


}
