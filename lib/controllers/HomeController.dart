
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroscoresliveline/ui/commonUi/CommonUi.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../Constant.dart';
import '../session/SessionManager.dart';
import '../ui/fixtures/teams/TeamPlayersList.dart';
import '../utils/common_dialog.dart';
import '../utils/styleUtil.dart';
import "package:http/http.dart" as http;

class HomeController extends ChangeNotifier {

  List liveDataList = [];
  bool liveMatch = false;

  Future<void> getLiveMatchList(context) async {
    liveMatch = false;
    // CommanDialog.showLoading(context);
    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.liveMatchList));
    // request.fields.addAll();
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response852  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        liveDataList = [];
        notifyListeners();
        if (data['status'] == true) {
          liveDataList = data["data"];
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            liveMatch = true;
            notifyListeners();
          });
        } else {
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 1000), () {
            liveMatch = true;
            notifyListeners();
          });
        }
      } else {
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 1000), () {
          liveMatch = true;
          notifyListeners();
        });
      }
    } catch (error) {
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 1000), () {
        liveMatch = true;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }


  List homeData = [];
  List homeDataFilter = [];
  List homeDataFilterDateWise = [];
  bool homeMatch = true;

  Future<void> getHomeList(context) async {
    homeMatch = true;
    // CommanDialog.showLoading(context);
    var request = http.MultipartRequest('GET', Uri.parse(Constant.homeList));
    // request.fields.addAll();
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        homeData = [];
        homeDataFilter = [];
        homeDataFilterDateWise = [];
        notifyListeners();
        if (data['status'] == true) {
          homeData = data["data"];
          for (int i = 0; i < homeData.length; i++) {
            if (homeData[i]["match_status"] == "Upcoming") {
              homeDataFilterDateWise.add(homeData[i]);
            }
          }
          homeDataFilter.addAll(dateWiseListResponse(homeDataFilterDateWise));
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            homeMatch = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            homeMatch = false;
            notifyListeners();
          });
        }
      } else {
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100), () {
          homeMatch = false;
          notifyListeners();
        });
      }
    } catch (error) {
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100), () {
        homeMatch = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }


  List upcomingMatchesList1 = [];
  bool upcomingMListLoading1 = true;

  Future<void> getRecentMatchesList1(context) async {
    upcomingMListLoading = true;
    // CommanDialog.showLoading(context);
    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.homeUpComingList));
    // request.fields.addAll();
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        upcomingMatchesList = [];
        notifyListeners();
        if (data['status'] == true) {
          List listData = data["data"];
          upcomingMatchesList = dateWiseListResponse(listData);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            upcomingMListLoading = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            upcomingMListLoading = false;
            notifyListeners();
          });
        }
      } else {
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100), () {
          upcomingMListLoading = false;
          notifyListeners();
        });
      }
    } catch (error) {
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100), () {
        finishedMListLoading = true;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  List upcomingMatchesList = [];
  List upcomingNewMatchesList = [];
  bool upcomingMListLoading = true;
  bool isLoadingMMore = false;
  int pageUp = 0;
  final int pageSizeUp = 10;

  Future<void> getUpcomingMatchesList(BuildContext context) async {
    if (pageUp == 0) {
      upcomingMListLoading = true;
      upcomingMatchesList = [];
      upcomingNewMatchesList = [];
    } else {
      isLoadingMMore = true;
    }
    notifyListeners();

    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.homeUpComingList));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          List listData = data["data"];
          upcomingNewMatchesList.addAll(listData);
          debugPrint("dkfdfd  $upcomingNewMatchesList");
          upcomingMatchesList.addAll(dateWiseListResponse(listData));
          if (pageUp == 0) {
            upcomingMListLoading = false;
          }
          isLoadingMore = false;
          notifyListeners();
        } else {
          showToast(data['msg']);
          if (pageUp == 0) {
            upcomingMListLoading = false;
          }
          isLoadingMore = false;
          notifyListeners();
        }
      } else {
        if (pageUp == 0) {
          upcomingMListLoading = false;
        }
        isLoadingMore = false;
        notifyListeners();
      }
    } catch (error) {
      if (pageUp == 0) {
        upcomingMListLoading = false;
      }
      isLoadingMore = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  List finishedMatchesList1 = [];
  bool finishedMListLoading1 = true;

  Future<void> getFinishedMatchesList1(context) async {
    finishedMListLoading = true;
    // CommanDialog.showLoading(context);
    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.recentMatches));
    // request.fields.addAll();
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        finishedMatchesList = [];
        notifyListeners();
        if (data['status'] == true) {
          List listData = data["data"];
          finishedMatchesList = dateWiseListResponse(listData);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            finishedMListLoading = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100), () {
            finishedMListLoading = false;
            notifyListeners();
          });
        }
      } else {
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100), () {
          finishedMListLoading = false;
          notifyListeners();
        });
      }
    } catch (error) {
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100), () {
        finishedMListLoading = true;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  List finishedMatchesList = [];
  bool finishedMListLoading = true;
  bool isLoadingMore = false;
  int page = 0;

  Future<void> getFinishedMatchesList(BuildContext context) async {
    if (page == 0) {
      finishedMListLoading = true;
      finishedMatchesList = [];
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.recentMatches));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          List listData = data["data"];
          finishedMatchesList.addAll(dateWiseListResponse(listData));
          if (page == 0) {
            finishedMListLoading = false;
          }
          isLoadingMore = false;
          notifyListeners();
        } else {
          showToast(data['msg']);
          if (page == 0) {
            finishedMListLoading = false;
          }
          isLoadingMore = false;
          notifyListeners();
        }
      } else {
        if (page == 0) {
          finishedMListLoading = false;
        }
        isLoadingMore = false;
        notifyListeners();
      }
    } catch (error) {
      if (page == 0) {
        finishedMListLoading = false;
      }
      isLoadingMore = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  Map homeAdsData = {};
  Future<void> getHomeAdsData(BuildContext context) async {
    bottomAds = [];
    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.adsList));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          homeAdsData = {};
          bottomAds.add(data["data"]);
          notifyListeners();
        } else {
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    } catch (error) {
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  /****************************************************************************************  Fixtures  *******************************************************************************/

  List fixturesDayMatchesList = [];
  List fixturesDayMatchesMainList = [];
  bool fixturesDayListLoading = true;
  bool isLoadingFDMore = false;
  int fdPage = 0;
  List match = ['All', 'T10', 'T20', 'ODI', 'TEST'];

  List t10List = [];
  List t20List = [];
  List odiList = [];
  List testList = [];

  // Variable to track the selected index
  int selectedIndex = 0;

  Future<void> getFixturesDayMatchesList(BuildContext context) async {
    if (fdPage == 0) {
      fixturesDayListLoading = true;
      fixturesDayMatchesList = [];
      fixturesDayMatchesMainList = [];
    } else {
      isLoadingFDMore = true;
    }
    selectedIndex = 0;
    notifyListeners();

    var request = http.MultipartRequest(
        'GET', Uri.parse(Constant.allLUMatches));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        t10List = [];
        t20List = [];
        odiList = [];
        testList = [];
        List t10ListTemp = [];
        List t20ListTemp = [];
        List odiListTemp = [];
        List testListTemp = [];
        if (data['status'] == true) {
          List listData = data["data"];
          fixturesDayMatchesMainList.addAll(dateWiseListResponse(listData));
          fixturesDayMatchesList.addAll(dateWiseListResponse(listData));
          // print("object $fixturesDayMatchesMainList");
          for (int i = 0; i < listData.length; i++) {
            if (listData[i]["match_type"] == "T10") {
              t10ListTemp.add(listData[i]);
            }
            if (listData[i]["match_type"] == "T20") {
              print("object123 ${listData[i]}");
              t20ListTemp.add(listData[i]);
            }
            if (listData[i]["match_type"] == "ODI") {
              odiListTemp.add(listData[i]);
            }
            if (listData[i]["match_type"] == "Test") {
              testListTemp.add(listData[i]);
            }
          }
          t10List.addAll(dateWiseListResponse(t10ListTemp));
          t20List.addAll(dateWiseListResponse(t20ListTemp));
          odiList.addAll(dateWiseListResponse(odiListTemp));
          testList.addAll(dateWiseListResponse(testListTemp));
          if (fdPage == 0) {
            fixturesDayListLoading = false;
          }

          Timer(const Duration(milliseconds: 100), () {
            isLoadingFDMore = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          if (fdPage == 0) {
            fixturesDayListLoading = false;
          }
          isLoadingFDMore = false;
          notifyListeners();
        }
      } else {
        if (fdPage == 0) {
          fixturesDayListLoading = false;
        }
        isLoadingFDMore = false;
        notifyListeners();
      }
    } catch (error) {
      if (fdPage == 0) {
        fixturesDayListLoading = false;
      }
      isLoadingFDMore = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  void onTabChange(int index) {
    if (index == 0) {
      fixturesDayMatchesList = fixturesDayMatchesMainList;
    } else if (index == 1) {
      fixturesDayMatchesList = t10List;
    } else if (index == 2) {
      fixturesDayMatchesList = t20List;
    } else if (index == 3) {
      fixturesDayMatchesList = odiList;
    } else if (index == 4) {
      fixturesDayMatchesList = testList;
    }
    print("object $index chanded   ${fixturesDayMatchesList.length}");
    notifyListeners();
  }


  List teamListData = [];
  bool loadingTeamList = true;
  bool isLoadingFTMore = true;
  int fTPage = 0;

  Future<void> getTeamsList(BuildContext context) async {
    if (fTPage == 0) {
      loadingTeamList = true;
      teamListData = [];
    } else {
      isLoadingFTMore = true;
    }
    notifyListeners();

    var request = http.MultipartRequest('GET', Uri.parse(Constant.teamList));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          teamListData = data["data"];
          if (fTPage == 0) {
            loadingTeamList = false;
          }
          isLoadingFTMore = false;
          notifyListeners();
        } else {
          showToast(data['msg']);
          if (fTPage == 0) {
            loadingTeamList = false;
          }
          isLoadingFTMore = false;
          notifyListeners();
        }
      } else {
        if (fTPage == 0) {
          loadingTeamList = false;
        }
        isLoadingFTMore = false;
        notifyListeners();
      }
    } catch (error) {
      if (fTPage == 0) {
        loadingTeamList = false;
      }
      isLoadingFTMore = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  bool isLoadingPlayer = true;
  List teamData = [];

  Future<void> getPlayerListByTeamId(context, String teamId) async {
    isLoadingPlayer = true;
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.playersByTeamId));
    request.fields.addAll({"team_id": teamId});
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
        teamData = [];
        notifyListeners();
        if (data['status'] == true) {
          teamData = data["data"];
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlayer = false;
            notifyListeners();
          });
        } else {
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100), () {
            isLoadingPlayer = false;
            notifyListeners();
          });
        }
      } else {
        Timer(const Duration(milliseconds: 100), () {
          isLoadingPlayer = false;
          notifyListeners();
        });
      }
    } catch (error) {
      Timer(const Duration(milliseconds: 100), () {
        isLoadingPlayer = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  void teamDetailBottomSheet(BuildContext context, String teamId,
      String teamName) async {
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
              TeamPlayersList(teamId: teamId, teamName: teamName)
      );
    });
  }


  void setStatusBarColor(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black, // Dark theme status bar color
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.blue, // Light theme status bar color
      ));
    }
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.system;
  bool isDarkMode = false;

  void changeTheme(ThemeMode themeMode1) {
      themeMode = themeMode1;
      SessionManager().changeAppTheme(isDarkMode);
      Timer(const Duration(milliseconds: 200),(){
        notifyListeners();
      });
  }

  void changeThemeNotify() {
        notifyListeners();
  }


  List bottomAds = [];
  Future<void> getBottomAds(BuildContext context) async {
    var request = http.MultipartRequest('GET', Uri.parse(Constant.adsBottomList));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response111111  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          bottomAds = data["data"];
          notifyListeners();
        } else {
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    } catch (error) {
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  List predictionList = [];
  bool isPredict = false;
  Future<void> getPrediction(BuildContext context) async {
    isPredict = true;
    var request = http.MultipartRequest('GET', Uri.parse(Constant.prediction));
    try {
      http.StreamedResponse response = await request.send();
      predictionList = [];
      isPredict = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response111111  $data");
        }
        if (data['status'] == true) {
          predictionList = data["data"];
          notifyListeners();
        } else {
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    } catch (error) {
      isPredict = false;
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

  List homeOpenAppAds = [];
  Future<void> getHomeOpenAds(BuildContext context) async {
    var request = http.MultipartRequest('GET', Uri.parse(Constant.adsAppList));
    try {
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response111444111  ${response.statusCode}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(await response.stream.bytesToString());
        if (data['status'] == true) {
          homeOpenAppAds = data["data"];
          notifyListeners();
        } else {
          notifyListeners();
        }
      } else {
        notifyListeners();
      }
    } catch (error) {
      notifyListeners();
      if (kDebugMode) {
        print("Error1 $error");
      }
    }
  }

}