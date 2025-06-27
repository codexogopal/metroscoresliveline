import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../controllers/HomeController.dart';
import '../theme/mythemcolor.dart';
import '../ui/commonUi/CommonUi.dart';
import 'common_color.dart';

TextStyle textStyle10(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(
      fontSize: 12,
      fontWeight: fontWeight,
      color: textColor,
      fontFamily: 'ssm',
      height: 1);
}

TextStyle textStyle10Normal(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(fontSize: 11, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle13(
    {FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black}) {
  return TextStyle(fontSize: 13, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle9({
  FontWeight fontWeight = FontWeight.normal,
  Color textColor = Colors.black,
}) {
  return TextStyle(fontSize: 9, fontWeight: fontWeight, color: textColor);
}

TextStyle textStyle12() {
  return TextStyle(fontSize: 12);
}

Future<bool?> showToast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    fontSize: 13.0,
    backgroundColor: Colors.black87,
  );
}

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.last;
  return fileName;
}

String formatDateTimeForLive(String dateTimeString) {
  dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('+'));
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('dd MMM yyyy @hh:mm a');

  String formattedDateTime = dateFormat.format(dateTime);
  return 'Start : $formattedDateTime';
}

String calculateResult(String firstP, String secP) {
  double firstPercentage = double.parse(firstP);
  double secPercentage = double.parse(secP);
  double difference = secPercentage - firstPercentage;
  double result = (difference / secPercentage) * 100;
  String formattedResult = result.toStringAsFixed(2);
  return "$formattedResult%";
}

String formatDateTime(String dateTimeString) {
  final originalDateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat.yMMMMd();
  return formatter.format(originalDateTime);
}

bool isValidIndianMobileNumber(String number) {
  // Add your logic to validate an Indian mobile number here
  // For simplicity, let's assume any 10-digit number is valid
  return number.length == 10;
}

bool validateEmail(String email) {
  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

String getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';

  for (int i = 0; i < nameParts.length && i < 2; i++) {
    String part = nameParts[i];
    if (part.isNotEmpty) {
      initials += part[0].toUpperCase();
    }
  }

  return initials;
}

Widget hrWidget() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(CommonColor.bgColor),
      height: 6,
      thickness: 6,
    ),
  );
}

Widget hrWidgetWithOutHeight() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    // child: Divider(color: Color(CommonAppTheme.bgColor),height: 0,thickness: 0,),
  );
}

Widget hrLightWidget(BuildContext context) {
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(isDarkTheme ? 0XFF0b151e : CommonColor.bgColor),
      height: 0,
      thickness: 1,
    ),
  );
}

Widget hrLightGreyWidget() {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: myprimarycolor.shade100,
      height: 0,
      thickness: 1,
    ),
  );
}

Widget hrLightWidget2() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Divider(
      color: Color(CommonColor.bgColor),
      height: 2,
      thickness: 1,
    ),
  );
}

String formatOrderTime(String timeStr) {
  // Parse the input time string
  List<String> parts = timeStr.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // Convert 24-hour format to 12-hour format
  String period = 'AM';
  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }

  // Format the time in "hh:mm a" format
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

TextStyle? mTextStyle(context) {
  return Theme.of(context)
      .textTheme
      .labelSmall
      ?.copyWith(fontWeight: FontWeight.w800, fontFamily: "sb", fontSize: 13);
}
TextStyle? mTextStyle1(context) {
  return Theme.of(context)
      .textTheme
      .titleMedium
      ?.copyWith(fontWeight: FontWeight.w800, fontFamily: "sb", fontSize: 13);
}

TextStyle? mItemTextStyle(context) {
  return Theme.of(context)
      .textTheme
      .titleLarge
      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 13);
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

Widget instagramFollowAds(BuildContext context, ){
  HomeController provider = Provider.of(context, listen: false);
  return Container(
    margin: const EdgeInsets.only(top: 0),
    width: MediaQuery.of(context).size.width,
    child: provider.bottomAds.isNotEmpty ? sliderView(context, provider.bottomAds) : const SizedBox(height: 0,),
  );
}

Widget sliderView(BuildContext context, List bannerList) {

  int _current = 0;
  CarouselSliderController  _controller = CarouselSliderController();
  HomeController provider = Provider.of(context, listen: false);
  late List<Widget> imageSliders = bannerList.map((item) =>
      InkWell(
        onTap: () {
          openWhatsApp(item["url"]);
        },
        child: Container(
          child: CachedNetworkImage(
            imageUrl: item["image"] ?? '${item["image"]}gp.png',
            imageBuilder: (context, imageProvider) => Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //image size fill
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/logo.png",
                height: 60,
                width: double.infinity,
                fit: BoxFit.fill,
              ), // you can add pre loader iamge as well to show loading.
            ), //show progress  while loading image
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/logo.png",
              height: 60,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            //show no image available image on error loading
          ),
        ),
      ))
      .toList();

  return Column(
    children: [
      Container(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              height: 60,
              viewportFraction: .99,
              aspectRatio: 0.2,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: false,
              onPageChanged: (index, reason) {
              }),
        ),
      ),
    ],
  );
}



Widget setCachedImage(String imgUrl, double myHeight, double myWidth, double imgRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(imgRadius),
    child: CachedNetworkImage(
      imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
      imageBuilder: (context, imageProvider) => Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(imgRadius),
          image: DecorationImage(
            //image size fill
            image: imageProvider,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/logo.png",
          height: myHeight,
          width: myWidth,
          fit: BoxFit.fill,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/logo.png",
        height: myHeight,
        width: myWidth,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget setCachedImageSeries(String imgUrl, double myHeight, double myWidth, double imgRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(imgRadius),
    child: CachedNetworkImage(
      imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
      imageBuilder: (context, imageProvider) => Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(imgRadius),
          image: DecorationImage(
            //image size fill
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/logo.png",
          height: myHeight,
          width: myWidth,
          fit: BoxFit.fill,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/logo.png",
        height: myHeight,
        width: myWidth,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget setCachedImageVenue(String imgUrl, double myHeight, double myWidth, double imgRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(imgRadius),
    child: CachedNetworkImage(
      imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
      imageBuilder: (context, imageProvider) => Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(imgRadius),
          image: DecorationImage(
            //image size fill
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/logo.png",
          height: myHeight,
          width: myWidth,
          fit: BoxFit.fill,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/logo.png",
        height: myHeight,
        width: myWidth,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget setSliderCachedImage(String imgUrl, double myHeight, double myWidth, double imgRadius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(imgRadius),
    child: CachedNetworkImage(
      imageUrl: imgUrl ?? 'https://www.google.com.au/image_url.png',
      imageBuilder: (context, imageProvider) => Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            //image size fill
            image: imageProvider,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/logo.png",
          height: myHeight,
          width: myWidth,
          fit: BoxFit.cover,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/logo.png",
        height: myHeight,
        width: myWidth,
        fit: BoxFit.cover,
      ),
    ),
  );
}


Widget gText(BuildContext context, String text){
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return GradientText(
    text,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontFamily: "b"),
    colors: /*isDarkTheme ? [Colors.white, Colors.white] :*/ [
      Color(0XFFfbaa22),
      Color(0XFFc9850c),
      Color(0XFFfbaa22),
      Color(0XFFfbaa22),
      Color(0XFFc9850c),
      Color(0XFFfbaa22),
      Color(0XFFc9850c),
      Color(0XFFfbaa22),
    ],
  );
}

LinearGradient mGradient(BuildContext context) {
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return isDarkTheme ?
  LinearGradient(colors: [
    Color(0XFFfba928).withAlpha(0),
    Color(0XFFfba928).withAlpha(40),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter) :
  LinearGradient(colors: [
    Color(0XFF302ebf).withAlpha(10),
    Color(0XFF302ebf).withAlpha(45),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

LinearGradient tabGradient(BuildContext context) {
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return isDarkTheme ?
  LinearGradient(colors: [
    Color(0XFFD12C7D).withAlpha(0),
    Color(0XFFD12C7D).withAlpha(50),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter) :
  LinearGradient(colors: [
    Color(0XFF302ebf).withAlpha(10),
    Color(0XFF302ebf).withAlpha(85),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

Widget mContainer({required BuildContext context, required Widget child}){
  return Container(
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(0),
  gradient: mGradient(context),
  ),
    child: child,
  );
}

BoxShadow mBoxShadow(BuildContext context){
  final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return BoxShadow(
      color: isDarkTheme ? Color(0XFFffffff).withAlpha(40) : Colors.black.withAlpha(40),
      blurRadius: 2.0,
      offset: Offset(0.0, 0.0)
  );
}