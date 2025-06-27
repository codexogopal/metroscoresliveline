
class Constant {
  static String appName = "Metro Live Line";
  static String lastBallGetStatus = "";
  static String PLAY_STORE_LINK = 'https://play.google.com/store/apps/details?id=com.metroscoresliveline.io';
  static String APP_STORE_LINK = 'https://apps.apple.com/in/app/';
  static String CONTACT_US_EMAIL = 'metrolivelines@gmail.com';

  static String BASE_URL_LIVE = "http://apicricketchampion.in/apiv4/";
  static String TOKEN = "86e7de92809e9e36ad2953e8b4adc294";

  static String WEB_SERVICE_URL = "https://metroliveline.com/webservices/";

  // Home API
  static String homeList = BASE_URL_LIVE+"homeList/"+TOKEN;
  static String homeUpComingList = BASE_URL_LIVE+"upcomingMatches/"+TOKEN;
  static String recentMatches = BASE_URL_LIVE+"recentMatches/"+TOKEN;

  // Match Detail API
  static String matchInfo = BASE_URL_LIVE+"matchInfo/"+TOKEN;

  static String playingXiByMatchId = BASE_URL_LIVE+"playingXiByMatchId/"+TOKEN;

  // Live Match
  static String liveMatchList = BASE_URL_LIVE+"liveMatchList/"+TOKEN;

  static String liveMatchData = BASE_URL_LIVE+"liveMatch/"+TOKEN;

  static String matchOddHistory = BASE_URL_LIVE+"matchOddHistory/"+TOKEN;

  static String commentary = BASE_URL_LIVE+"commentary/"+TOKEN;

  static String scorecardByMatchId = BASE_URL_LIVE+"scorecardByMatchId/"+TOKEN;

  static String matchFancy = BASE_URL_LIVE+"matchFancy/"+TOKEN;

  static String allLUMatches = BASE_URL_LIVE+"allLUMatches/"+TOKEN;

  static String teamList = BASE_URL_LIVE+"teamList/"+TOKEN;

  static String playersByTeamId = BASE_URL_LIVE+"playersByTeamId/"+TOKEN;

  // News API
  static String newsList = BASE_URL_LIVE+"news/"+TOKEN;

  // Series API
  static String seriesList = BASE_URL_LIVE+"seriesList/"+TOKEN;
  static String fixtureSeriesList = BASE_URL_LIVE+"upcomingMatchesBySeriesId/"+TOKEN;
  static String recentMatchesBySeriesId = BASE_URL_LIVE+"recentMatchesBySeriesId/"+TOKEN;
  static String recentSquadsList = BASE_URL_LIVE+"squadsBySeriesId/"+TOKEN;
  static String pointsTable = BASE_URL_LIVE+"pointsTable/"+TOKEN;
  static String venuesList = BASE_URL_LIVE+"venuesBySeriesId/"+TOKEN;

  // venue Detail
  static String venuesDetail = BASE_URL_LIVE+"venuesDetail/"+TOKEN;

  // player
  static String playerInfo = BASE_URL_LIVE+"playerInfo/"+TOKEN;

  static String manOfTheSeries = BASE_URL_LIVE+"manOfTheSeries/"+TOKEN;

  /************************************************************************Over web service **************************************************************************/


  static String adsBottomList = WEB_SERVICE_URL+'adsBottomList';

  static String adsAppList = WEB_SERVICE_URL+'adsAppList';

  static String social = WEB_SERVICE_URL+'socialList';

  static String prediction = WEB_SERVICE_URL+'social';

  /****************************************************************************************************************************************************************/
  static String signupAds = WEB_SERVICE_URL+"signupAds";

  static String signup = WEB_SERVICE_URL+"signup";

  static String verify = WEB_SERVICE_URL+"verify";

  static String checkPrediction = WEB_SERVICE_URL+"checkPrediction";

  static String predictionData = WEB_SERVICE_URL+'predictionData';

  static String planList = WEB_SERVICE_URL+"planList";

  static String UPI_API = WEB_SERVICE_URL+'upi';

  static String purchasePlan = WEB_SERVICE_URL+'purchasePlan';

  static String transactionList = WEB_SERVICE_URL+'transactionList';


  static String contact = WEB_SERVICE_URL+'contact';

  static String adsList = WEB_SERVICE_URL+'adsList';


  static String privacyPolicy = "https://metroscores.com/privacy-policy";

  static String termsCondition = 'https://metroscores.com/terms-condition';



  /****************************************************************************************************************************************************************/




  static String TERMS = """
<p>These terms and conditions (&quot;Terms&quot;, &quot;Agreement&quot;) are an agreement between Website Operator (&quot;Website Operator&quot;, &quot;us&quot;, &quot;we&quot; or &quot;our&quot;) and you (&quot;User&quot;, &quot;you&quot; or &quot;your&quot;). This Agreement sets forth the general terms and conditions of your use of the metroscoresliveline.co.in website and any of its products or services (collectively, &quot;Website&quot; or &quot;Services&quot;).</p>
<p>Backups<br />We are not responsible for Content residing on the Website. In no event shall we be held liable for any loss of any Content. It is your sole responsibility to maintain appropriate backup of your Content. Notwithstanding the foregoing, on some occasions and in certain circumstances, with absolutely no obligation, we may be able to restore some or all of your data that has been deleted as of a certain date and time when we may have backed up data for our own purposes. We make no guarantee that the data you need will be available.</p>
<p>Changes and amendments<br />We reserve the right to modify this Agreement or its policies relating to the Website or Services at any time, effective upon posting of an updated version of this Agreement on the Website. When we do, we will send you an email to notify you. Continued use of the Website after any such changes shall constitute your consent to such changes.&nbsp;</p>
<p>Acceptance of these terms<br />You acknowledge that you have read this Agreement and agree to all its terms and conditions. By using the Website or its Services you agree to be bound by this Agreement. If you do not agree to abide by the terms of this Agreement, you are not authorized to use or access the Website and its Services.</p>
<p>Contacting us<br />If you have any questions about this Agreement, please contact us.</p>
""";

  static String ABOUT_US = """
<p>$appName provides you with the cricket entertainment from live score to each and every latest news updates on your fingertips. It offers a complete package about the whole cricket game.</p>
<p>You can get various cricket match information like the score card, latest cricket updates, latest cricket news and updates of cricket matches. It also covers an unbeatable coverage of cricket matches to their viewers all over the world. In this app, you will have the chance to see match live score, schedules, exclusives and expert opinions.</p>
<p>Apart from the above mentioned, it serves as a source of information to cricket fans like details of latest news, live score card, latest update about cricket matches and other valuable cricket information.</p>
""";



  static String PRIVACY_POLICY = """
   <div class="content-wrapper">
            <!-- <iframe src="https://tele.bazigarprediction.website/index.html?MatchID=33275626" height="200" width="300" title="Iframe Example"></iframe> -->


<h1>Privacy policy</h1>

<p>This privacy policy (&quot;Policy&quot;) describes how Website Operator (&quot;Website Operator&quot;, &quot;we&quot;, &quot;us&quot; or &quot;our&quot;) collects, protects and uses the personally identifiable information (&quot;Personal Information&quot;) you (&quot;User&quot;, &quot;you&quot; or &quot;your&quot;) may provide on the website and any of its products or services (collectively, &quot;Website&quot; or &quot;Services&quot;). It also describes the choices available to you regarding our use of your Personal Information and how you can access and update this information. This Policy does not apply to the practices of companies that we do not own or control, or to individuals that we do not employ or manage.</p>

<h2>Collection of personal information</h2>

<p>We receive and store any information you knowingly provide to us when you fill any online forms on the Website. You can choose not to provide us with certain information, but then you may not be able to take advantage of some of the Website&#39;s features. Users who are uncertain about what information is mandatory are welcome to contact us.</p>

<h2>Collection of non-personal information</h2>

<p>When you visit the Website our servers automatically record information that your browser sends. This data may include information such as your device&#39;s IP address, browser type and version, operating system type and version, language preferences or the webpage you were visiting before you came to our Website, pages of our Website that you visit, the time spent on those pages, information you search for on our Website, access times and dates, and other statistics.</p>

<h2>Use of collected information</h2>

<p>Any of the information we collect from you may be used to improve our Website; improve customer service and respond to queries and emails of our customers; send notification emails such as password reminders, updates, etc; run and operate our Website and Services. Non-Personal Information collected is used only to identify potential cases of abuse and establish statistical information regarding Website usage. This statistical information is not otherwise aggregated in such a way that would identify any particular user of the system.</p>

<h2>Privacy of children</h2>

<p>We do not knowingly collect any Personal Information from children under the age of 13. If you are under the age of 13, please do not submit any Personal Information through our Website or Service. We encourage parents and legal guardians to monitor their children&#39;s Internet usage and to help enforce this Policy by instructing their children never to provide Personal Information through our Website or Service without their permission. If you have reason to believe that a child under the age of 13 has provided Personal Information to us through our Website or Service, please contact us. You must also be old enough to consent to the processing of your personal data in your country (in some countries we may allow your parent or guardian to do so on your behalf).</p>

<h2>Do Not Track signals</h2>

<p>Some browsers incorporate a Do Not Track feature that signals to websites you visit that you do not want to have your online activity tracked. Tracking is not the same as using or collecting information in connection with a website. For these purposes, tracking refers to collecting personally identifiable information from consumers who use or visit a website or online service as they move across different websites over time. How browsers communicate the Do Not Track signal is not yet uniform. As a result, this Website is not yet set up to interpret or respond to Do Not Track signals communicated by your browser. Even so, as described in more detail throughout this Policy, we limit our use and collection of your personal information.</p>

<h2>Information security</h2>

<p>We secure information you provide on computer servers in a controlled, secure environment, protected from unauthorized access, use, or disclosure. We maintain reasonable administrative, technical, and physical safeguards in an effort to protect against unauthorized access, use, modification, and disclosure of Personal Information in its control and custody. However, no data transmission over the Internet or wireless network can be guaranteed. Therefore, while we strive to protect your Personal Information, you acknowledge that (i) there are security and privacy limitations of the Internet which are beyond our control; (ii) the security, integrity, and privacy of any and all information and data exchanged between you and our Website cannot be guaranteed; and (iii) any such information and data may be viewed or tampered with in transit by a third-party, despite best efforts.</p>

<h2>Changes and amendments</h2>

<p>We reserve the right to modify this Policy relating to the Website or Services at any time, effective upon posting of an updated version of this Policy on the Website. When we do we will send you an email to notify you. Continued use of the Website after any such changes shall constitute your consent to such changes.&nbsp;</p>

<h2>Acceptance of this policy</h2>

<p>You acknowledge that you have read this Policy and agree to all its terms and conditions. By using the Website or its Services you agree to be bound by this Policy. If you do not agree to abide by the terms of this Policy, you are not authorized to use or access the Website and its Services.</p>

<h2>Contacting us</h2>

<p>If you have any questions about this Policy, please contact us.</p>

<h1>Privacy policy</h1>

<p>This privacy policy (&quot;Policy&quot;) describes how Website Operator (&quot;Website Operator&quot;, &quot;we&quot;, &quot;us&quot; or &quot;our&quot;) collects, protects and uses the personally identifiable information (&quot;Personal Information&quot;) you (&quot;User&quot;, &quot;you&quot; or &quot;your&quot;) may provide on the website and any of its products or services (collectively, &quot;Website&quot; or &quot;Services&quot;). It also describes the choices available to you regarding our use of your Personal Information and how you can access and update this information. This Policy does not apply to the practices of companies that we do not own or control, or to individuals that we do not employ or manage.</p>

<h2>Collection of personal information</h2>

<p>We receive and store any information you knowingly provide to us when you fill any online forms on the Website. You can choose not to provide us with certain information, but then you may not be able to take advantage of some of the Website&#39;s features. Users who are uncertain about what information is mandatory are welcome to contact us.</p>

<h2>Collection of non-personal information</h2>

<p>When you visit the Website our servers automatically record information that your browser sends. This data may include information such as your device&#39;s IP address, browser type and version, operating system type and version, language preferences or the webpage you were visiting before you came to our Website, pages of our Website that you visit, the time spent on those pages, information you search for on our Website, access times and dates, and other statistics.</p>

<h2>Use of collected information</h2>

<p>Any of the information we collect from you may be used to improve our Website; improve customer service and respond to queries and emails of our customers; send notification emails such as password reminders, updates, etc; run and operate our Website and Services. Non-Personal Information collected is used only to identify potential cases of abuse and establish statistical information regarding Website usage. This statistical information is not otherwise aggregated in such a way that would identify any particular user of the system.</p>

<h2>Privacy of children</h2>

<p>We do not knowingly collect any Personal Information from children under the age of 13. If you are under the age of 13, please do not submit any Personal Information through our Website or Service. We encourage parents and legal guardians to monitor their children&#39;s Internet usage and to help enforce this Policy by instructing their children never to provide Personal Information through our Website or Service without their permission. If you have reason to believe that a child under the age of 13 has provided Personal Information to us through our Website or Service, please contact us. You must also be old enough to consent to the processing of your personal data in your country (in some countries we may allow your parent or guardian to do so on your behalf).</p>

<h2>Do Not Track signals</h2>

<p>Some browsers incorporate a Do Not Track feature that signals to websites you visit that you do not want to have your online activity tracked. Tracking is not the same as using or collecting information in connection with a website. For these purposes, tracking refers to collecting personally identifiable information from consumers who use or visit a website or online service as they move across different websites over time. How browsers communicate the Do Not Track signal is not yet uniform. As a result, this Website is not yet set up to interpret or respond to Do Not Track signals communicated by your browser. Even so, as described in more detail throughout this Policy, we limit our use and collection of your personal information.</p>

<h2>Information security</h2>

<p>We secure information you provide on computer servers in a controlled, secure environment, protected from unauthorized access, use, or disclosure. We maintain reasonable administrative, technical, and physical safeguards in an effort to protect against unauthorized access, use, modification, and disclosure of Personal Information in its control and custody. However, no data transmission over the Internet or wireless network can be guaranteed. Therefore, while we strive to protect your Personal Information, you acknowledge that (i) there are security and privacy limitations of the Internet which are beyond our control; (ii) the security, integrity, and privacy of any and all information and data exchanged between you and our Website cannot be guaranteed; and (iii) any such information and data may be viewed or tampered with in transit by a third-party, despite best efforts.</p>

<h2>Changes and amendments</h2>

<p>We reserve the right to modify this Policy relating to the Website or Services at any time, effective upon posting of an updated version of this Policy on the Website. When we do we will send you an email to notify you. Continued use of the Website after any such changes shall constitute your consent to such changes.&nbsp;</p>

<h2>Acceptance of this policy</h2>

<p>You acknowledge that you have read this Policy and agree to all its terms and conditions. By using the Website or its Services you agree to be bound by this Policy. If you do not agree to abide by the terms of this Policy, you are not authorized to use or access the Website and its Services.</p>

<h2>Contacting us</h2>

<p>If you have any questions about this Policy, please contact us.</p>
        </div>
  """;

}
