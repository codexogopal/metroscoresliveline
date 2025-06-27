
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import '../session/SessionManager.dart';
import '../utils/common_dialog.dart';
import "package:http/http.dart" as http;

import '../utils/styleUtil.dart';

class MyTransactionController extends ChangeNotifier{

  List myTransactionData = [];

  Future<void> getMyTransactionList(context) async {
    CommanDialog.showLoading(context);
    myTransactionData = [];
    Map<String, String> userData = {
      "user_id" : SessionManager.getUserId().toString() ?? ""
    };
    notifyListeners();
    var request = http.MultipartRequest('POST', Uri.parse(Constant.transactionList));
    request.fields.addAll(userData);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if(data['status'] == true){
          myTransactionData = data["data"];
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
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


  List socialData = [];

  Future<void> getSocialData(context) async {
    CommanDialog.showLoading(context);
    notifyListeners();
    var request = http.MultipartRequest('GET', Uri.parse(Constant.social));
    // request.fields.addAll(userData);
    try{
      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if (kDebugMode) {
          print("response123  ${data}");
        }
        if(data['status'] == true){
          socialData = data["data"];
          CommanDialog.hideLoading();
          Timer(const Duration(milliseconds: 100),(){
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

  Future<void> getContactUs(context, Map<String, String> userData) async {
    CommanDialog.showLoading(context);
    notifyListeners();
    var request = http.MultipartRequest('POST', Uri.parse(Constant.contact));
    request.fields.addAll(userData);
    try{
      http.StreamedResponse response = await request.send();
      if (kDebugMode) {
        print("response  ${response.statusCode}");
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        Map data = json.decode(await response.stream.bytesToString());
        if(data['status'] == true){
          showToast(data['message']);
          CommanDialog.hideLoading();
          Navigator.of(context).pop();
          Timer(const Duration(milliseconds: 100),(){
            notifyListeners();
          });
        }else{
          showToast(data['message']);
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
}