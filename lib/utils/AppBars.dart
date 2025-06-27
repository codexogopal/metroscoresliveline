
import 'package:flutter/material.dart';
import 'package:metroscoresliveline/theme/mythemcolor.dart';

class AppBars {
  static AppBar myAppBar(String title, context, bool isShowIcon) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 3,
      shadowColor: Colors.black38,
      titleSpacing: isShowIcon ? -5 : -30,
      title: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'm', fontSize: 16, fontWeight: FontWeight.bold,),
      ),
      leading: Visibility(
        visible: isShowIcon,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).indicatorColor),
    );
  }
}

AppBar myStatusBar(){
  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
  );
}