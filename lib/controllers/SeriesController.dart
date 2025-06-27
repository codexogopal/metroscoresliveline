
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import '../ui/commonUi/CommonUi.dart';
import '../ui/series/CommonFiles/PlayerDetailsScreen.dart';
import '../ui/series/CommonFiles/VenuesDetails.dart';
import '../utils/common_dialog.dart';
import '../utils/styleUtil.dart';
import "package:http/http.dart" as http;

class SeriesController extends ChangeNotifier{
  List seriesListData = [];
  int? selectedIndex = 0;
  Map selectedSeriesData = {};
  bool haveFixturesReload = true;
  bool haveRecentReload = true;
  bool haveSquadsReload = true;
  bool havePointsTableReload = true;
  bool haveVenuesReload = true;
  void selectItem(int? index, Map selectedMap) {
    // selectedIndex = index;
    selectedIndex = selectedMap["series_id"];
    selectedSeriesData = selectedMap;
    haveFixturesReload = true;
    haveRecentReload = true;
    haveSquadsReload = true;
    havePointsTableReload = true;
    haveVenuesReload = true;
    notifyListeners();
  }

  bool seriesLoading = false;
  Future<void> getSeriesList(context) async {
    CommanDialog.showLoading(context);
    seriesLoading = false;
    var request = http.MultipartRequest('GET', Uri.parse(Constant.seriesList));
    // request.fields.addAll();
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        seriesListData = [];
        notifyListeners();
        if(data['status'] == true){
          seriesListData = data["data"];
          if(selectedIndex == 0){
            selectedSeriesData = seriesListData[0];
            selectedIndex = seriesListData[0]["series_id"];
            Map<String, String> series_id = {
              "series_id" : selectedIndex.toString()
            };
            getManOfPlayerDataById(context, series_id);
          }
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            seriesLoading = true;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            seriesLoading = true;
            notifyListeners();
          });
        }
      }else{
        CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          seriesLoading = true;
          notifyListeners();
        });
      }
    }catch(error){
      CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        seriesLoading = true;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  List seriesFixturesListData = [];
  bool fixturesListLoading = true;
  Future<void> getFixturesList(context, Map<String, String> seriesId) async {
    fixturesListLoading = true;
    haveFixturesReload = false;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.fixtureSeriesList));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        seriesFixturesListData = [];
        notifyListeners();
        if(data['status'] == true){
          List listData = data["data"];
          seriesFixturesListData = dateWiseListResponse(listData);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            fixturesListLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            fixturesListLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          fixturesListLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        fixturesListLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  List recentMatchesList = [];
  bool recentMListLoading = true;
  Future<void> getRecentMatchesList(context, Map<String, String> seriesId) async {
    // CommanDialog.showLoading(context);
    recentMListLoading = true;
    haveRecentReload = false;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.recentMatchesBySeriesId));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        recentMatchesList = [];
        notifyListeners();
        if(data['status'] == true){
          List listData = data["data"];
          recentMatchesList = dateWiseListResponse(listData);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            recentMListLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            recentMListLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          recentMListLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        recentMListLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  List squadsList = [];
  bool squadsLoading = true;
  Future<void> getSquadsListMatchesList(context, Map<String, String> seriesId) async {
    // CommanDialog.showLoading(context);
    squadsLoading = true;
    haveSquadsReload = false;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.recentSquadsList));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        squadsList = [];
        notifyListeners();
        if(data['status'] == true){
          squadsList = data["data"];
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            squadsLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            squadsLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          squadsLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        squadsLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  List pointsTableList = [];
  bool pointsLoading = true;
  Future<void> getPointsTableList(context, Map<String, String> seriesId) async {
    // CommanDialog.showLoading(context);
    pointsLoading = true;
    havePointsTableReload = false;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.pointsTable));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        pointsTableList = [];
        notifyListeners();
        if(data['status'] == true){
          pointsTableList = data["data"];
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            pointsLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            pointsLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          pointsLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        pointsLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  List venuesList = [];
  bool venuesLoading = true;
  Future<void> getVenuesList(context, Map<String, String> seriesId) async {
    // CommanDialog.showLoading(context);
    venuesLoading = true;
    haveVenuesReload = false;
    var request = http.MultipartRequest('POST', Uri.parse(Constant.venuesList));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        venuesList = [];
        notifyListeners();
        if(data['status'] == true){
          venuesList = data["data"];
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            venuesLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            venuesLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          venuesLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        venuesLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  Map playerData = {};
  Future<void> getPlayerDataById(context, Map<String, String> playerId) async {
    CommanDialog.showLoading(context);
    var request = http.MultipartRequest('POST', Uri.parse(Constant.playerInfo));
    request.fields.addAll(playerId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        playerData = {};
        notifyListeners();
        if(data['status'] == true){
          playerData = data["data"];
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerDetailsScreen(playerData: playerData, isHeaderShow: true,)));
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            notifyListeners();
          });
        }
      }else{
        CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          notifyListeners();
        });
      }
    }catch(error){
      CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  Map venueDataData = {};
  Future<void> getVenueDataById(context, Map<String, String> seriesId) async {
    print("response  ${seriesId.toString()}");
    CommanDialog.showLoading(context);
    var request = http.MultipartRequest('POST', Uri.parse(Constant.venuesDetail));
    request.fields.addAll(seriesId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  $data");
        }
        venueDataData = {};
        notifyListeners();
        if(data['status'] == true){
          venueDataData = data["data"];
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VenuesDetails()));
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            notifyListeners();
          });
        }
      }else{
        CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          notifyListeners();
        });
      }
    }catch(error){
      CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }


  /************************************************************************* Fixtures Series ***********************************************************************************/

  List seriesForFixturesListData = [];
  bool seriesForFixtLoading = true;

  bool fixturesDayListLoading = true;
  int fdPage = 0;
  Future<void> getSeriesForFixturesList(context) async {
    seriesForFixtLoading = true;
    var request = http.MultipartRequest('GET', Uri.parse(Constant.seriesList));
    // request.fields.addAll();
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response  ${data}");
        }
        seriesForFixturesListData = [];
        notifyListeners();
        if(data['status'] == true){
          List seriesListData = data["data"];
          seriesForFixturesListData.addAll(monthWiseListResponse(seriesListData));
          if (fdPage == 0) {
            fixturesDayListLoading = false;
          }
          Timer(const Duration(milliseconds: 100),(){
            seriesForFixtLoading = false;
            notifyListeners();
          });
        }else{
          if (fdPage == 0) {
            fixturesDayListLoading = false;
          }
          showToast(data['msg']);
          Timer(const Duration(milliseconds: 100),(){
            seriesForFixtLoading = false;
            notifyListeners();
          });
        }
      }else{
        if (fdPage == 0) {
          fixturesDayListLoading = false;
        }
        Timer(const Duration(milliseconds: 100),(){
          seriesForFixtLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      if (fdPage == 0) {
        fixturesDayListLoading = false;
      }
      Timer(const Duration(milliseconds: 100),(){
        seriesForFixtLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

  Map manOfTheMatchPlayerData = {};
  Future<void> getManOfPlayerDataById(context, Map<String, String> playerId) async {
    var request = http.MultipartRequest('POST', Uri.parse(Constant.manOfTheSeries));
    request.fields.addAll(playerId);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("responseHi  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("manOfTheMatchPlayerData  ${data}");
        }
        manOfTheMatchPlayerData = {};
        notifyListeners();
        if(data['status'] == true){
          manOfTheMatchPlayerData = data["data"];
          Timer(const Duration(milliseconds: 100),(){
            notifyListeners();
          });
        }else{
          Timer(const Duration(milliseconds: 100),(){
            notifyListeners();
          });
        }
      }else{
        Timer(const Duration(milliseconds: 100),(){
          notifyListeners();
        });
      }
    }catch(error){
      Timer(const Duration(milliseconds: 100),(){
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }

}