import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adevindustries/api/apiProvider.dart';
import 'package:adevindustries/constance/constance.dart';
import 'package:adevindustries/constance/global.dart';
import 'package:adevindustries/constance/themes.dart';
import 'package:adevindustries/model/liveCryptoNewsModel.dart';
import 'package:adevindustries/modules/news/newsDescription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adevindustries/constance/global.dart' as globals;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CryptoNews extends StatefulWidget {
  @override
  _CryptoNewsState createState() => _CryptoNewsState();
}

class _CryptoNewsState extends State<CryptoNews> {
  var appBarheight = 0.0;
  bool _isInProgress = false;

  late CryptoNewsLive cryptoNewsLive;

  @override
  void initState() {
    super.initState();
    getLatestNews();
  }

  getLatestNews() async {
    setState(() {
      _isInProgress = true;
    });
    cryptoNewsLive = await ApiProvider().cryptoNews('Bitcoin');
    setState(() {
      _isInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    appBarheight = appBar.preferredSize.height;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor(globals.primaryColorString).withOpacity(0.9),
                HexColor(globals.primaryColorString).withOpacity(0.8),
                HexColor(globals.primaryColorString).withOpacity(0.7),
                HexColor(globals.primaryColorString).withOpacity(0.6),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
          body: ModalProgressHUD(
            inAsyncCall: _isInProgress,
            opacity: 0,
            progressIndicator: CupertinoActivityIndicator(
              radius: 12,
            ),
            child: !_isInProgress
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: appBarheight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Animator<Offset>(
                                tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0.2, 0)),
                                duration: Duration(milliseconds: 500),
                                cycles: 0,
                                builder: (_, anim, __) => FractionalTranslation(
                                  translation: anim.value,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                            ),
                            Animator<double>(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.decelerate,
                              cycles: 1,
                              builder: (_, anim, __) => Transform.scale(
                                scale: anim.value,
                                child: Text(
                                  'Live Crypto News',
                                  style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontSize: ConstanceData.SIZE_TITLE18,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.notifications,
                              color: AllCoustomTheme.getsecoundTextThemeColor(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 16, top: 0),
                          itemCount: cryptoNewsLive.articles!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Animator<double>(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.decelerate,
                              cycles: 1,
                              builder: (_, anim, __) => Transform.scale(
                                scale: anim.value,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) => NewsDescription(
                                          title: cryptoNewsLive.articles![index].title,
                                          url: cryptoNewsLive.articles![index].url,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      MagicBoxGradiantLine(
                                        height: 3,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(27),
                                          ),
                                          color: AllCoustomTheme.boxColor(),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              semanticContainer: true,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                              ),
                                              margin: EdgeInsets.all(0),
                                              // ignore: unnecessary_null_comparison
                                              child: cryptoNewsLive.articles![index] != null &&
                                                      // ignore: unnecessary_null_comparison
                                                      cryptoNewsLive.articles![index].urlToImage != null &&
                                                      cryptoNewsLive.articles![index].urlToImage != ''
                                                  ? CachedNetworkImage(
                                                      errorWidget: (context, url, error) => CircleAvatar(
                                                        backgroundColor: AllCoustomTheme.getsecoundTextThemeColor(),
                                                        child: Icon(
                                                          Icons.error_outline,
                                                        ),
                                                      ),
                                                      imageUrl: cryptoNewsLive.articles![index].urlToImage,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : SizedBox(),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              // ignore: unnecessary_null_comparison
                                              cryptoNewsLive.articles![index].title != null && cryptoNewsLive.articles![index].title != ""
                                                  ? cryptoNewsLive.articles![index].title
                                                  : "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme.getTextThemeColors(),
                                                fontSize: ConstanceData.SIZE_TITLE14,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: Text(
                                                // ignore: unnecessary_null_comparison
                                                cryptoNewsLive.articles![index].description != null &&
                                                        cryptoNewsLive.articles![index].description != ""
                                                    ? cryptoNewsLive.articles![index].description
                                                    : "",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: AllCoustomTheme.getsecoundTextThemeColor(),
                                                  fontSize: ConstanceData.SIZE_TITLE14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'Author',
                                                        style: TextStyle(
                                                          color: AllCoustomTheme.getTextThemeColors(),
                                                          fontSize: ConstanceData.SIZE_TITLE14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        // ignore: unnecessary_null_comparison
                                                        cryptoNewsLive.articles![index].author != null && cryptoNewsLive.articles![index].author != ""
                                                            ? cryptoNewsLive.articles![index].author
                                                            : "",
                                                        style: TextStyle(
                                                          color: AllCoustomTheme.getsecoundTextThemeColor(),
                                                          fontSize: ConstanceData.SIZE_TITLE14,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 18),
                                                    child: Text(
                                                      getConvertTime(
                                                        cryptoNewsLive.articles![index].publishedAt.toString(),
                                                      ),
                                                      style: TextStyle(
                                                        color: AllCoustomTheme.getTextThemeColors(),
                                                        fontSize: ConstanceData.SIZE_TITLE12,
                                                      ),
                                                    ),
                                                  ),
                                                  Animator<double>(
                                                    tween: Tween<double>(begin: 0.8, end: 1.1),
                                                    curve: Curves.easeInToLinear,
                                                    cycles: 0,
                                                    builder: (_, anim, __) => Transform.scale(
                                                      scale: anim.value,
                                                      child: Container(
                                                        height: 28,
                                                        width: 28,
                                                        decoration: BoxDecoration(
                                                          border: new Border.all(color: Colors.white, width: 1.5),
                                                          shape: BoxShape.circle,
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                            colors: [
                                                              globals.buttoncolor1,
                                                              globals.buttoncolor2,
                                                            ],
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 3),
                                                          child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            size: 14,
                                                            color: AllCoustomTheme.getTextThemeColors(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ),
        )
      ],
    );
  }
}
