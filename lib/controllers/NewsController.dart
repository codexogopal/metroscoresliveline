
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import '../utils/common_dialog.dart';
import "package:http/http.dart" as http;

import '../utils/styleUtil.dart';

class NewsController extends ChangeNotifier{

  List newsData = [];

  bool newsLoading = true;
  Future<void> getNewsList(context) async {
    newsData = [];
    newsLoading = true;
    notifyListeners();
    var request = http.MultipartRequest('GET', Uri.parse(Constant.newsList));
    // request.fields.addAll();
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if(data['status'] == true){
          newsData = data["data"];
          // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            newsLoading = false;
            notifyListeners();
          });
        }else{
          showToast(data['msg']);
        // CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
            newsLoading = false;
            notifyListeners();
          });
        }
      }else{
        // CommanDialog.hideLoading();
        Timer(const Duration(milliseconds: 100),(){
          newsLoading = false;
          notifyListeners();
        });
      }
    }catch(error){
      // CommanDialog.hideLoading();
      Timer(const Duration(milliseconds: 100),(){
        newsLoading = false;
        notifyListeners();
      });
      if (kDebugMode) {
        print("Error $error");
      }
    }
  }
}