// ignore_for_file: deprecated_member_use

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adevindustries/constance/constance.dart';
import 'package:adevindustries/constance/global.dart';
import 'package:adevindustries/constance/themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:adevindustries/constance/global.dart' as globals;

class SliderOpen extends StatefulWidget {
  final String coinSymbol;
  final String coinName;
  final String price;
  final String percentchange1h;
  final String marketCap;
  final String volume;
  final String availableSupply;
  final String changein24HR;

  const SliderOpen(
      {key,
      required this.coinSymbol,
      required this.coinName,
      required this.price,
      required this.percentchange1h,
      required this.marketCap,
      required this.volume,
      required this.availableSupply,
      required this.changein24HR})
      : super(key: key);
  @override
  _SliderOpenState createState() => _SliderOpenState();
}

class _SliderOpenState extends State<SliderOpen> {
  bool isLoadingSliderDetail = false;

  @override
  void initState() {
    super.initState();
    loadingSliderDetail();
  }

  loadingSliderDetail() async {
    setState(() {
      isLoadingSliderDetail = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoadingSliderDetail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Animator<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(0, -0.2),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(milliseconds: 500),
                  cycles: 0,
                  builder: (_, anim, __) => FractionalTranslation(
                    translation: anim.value,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        FontAwesomeIcons.angleDown,
                        color: AllCoustomTheme.getTextThemeColors(),
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: <Widget>[
                Animator<double>(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  cycles: 1,
                  builder: (_, anim, __) => Transform.scale(
                    scale: anim.value,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AllCoustomTheme.getsecoundTextThemeColor(),
                          child: Text(
                            widget.coinSymbol.substring(0, 1),
                          ),
                        ),
                        imageUrl: coinImageURL + widget.coinSymbol.toLowerCase() + "@2x.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Animator<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500),
                  cycles: 1,
                  builder: (_, anim, __) => SizeTransition(
                    sizeFactor: anim.animation,
                    axis: Axis.horizontal,
                    axisAlignment: 1,
                    child: Text(
                      widget.coinName,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontSize: ConstanceData.SIZE_TITLE25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: <Widget>[
                Animator<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500),
                  cycles: 1,
                  builder: (_, anim, __) => SizeTransition(
                    sizeFactor: anim.animation,
                    axis: Axis.horizontal,
                    axisAlignment: 1,
                    child: Text(
                      '\$' + double.parse(widget.price).toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Ubuntu',
                        fontSize: ConstanceData.SIZE_TITLE16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Animator<double>(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.5, end: 1),
                  curve: Curves.fastOutSlowIn,
                  cycles: 0,
                  builder: (_, anim, __) => Transform.scale(
                    scale: anim.value,
                    child: new Container(
                      height: 40.0,
                      alignment: FractionalOffset.center,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(30),
                        color: Colors.green,
                      ),
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                  ),
                )),
                SizedBox(
                  width: 120,
                ),
                Expanded(
                  child: new Container(
                    height: 40.0,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Animator<Offset>(
                          tween: Tween<Offset>(
                            begin: Offset(0, -0.2),
                            end: Offset(0, 0),
                          ),
                          duration: Duration(milliseconds: 500),
                          cycles: 0,
                          builder: (_, anim, __) => FractionalTranslation(
                            translation: anim.value,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: widget.percentchange1h.contains('-')
                                  ? Icon(
                                      Icons.arrow_downward,
                                      color: AllCoustomTheme.getTextThemeColors(),
                                      size: 18,
                                    )
                                  : Icon(
                                      Icons.arrow_upward,
                                      color: AllCoustomTheme.getTextThemeColors(),
                                      size: 18,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          double.parse(widget.percentchange1h).toStringAsFixed(2) + '%',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: AllCoustomTheme.getTextThemeColors(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '1W',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 25.0,
                  width: 40,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AllCoustomTheme.getsecoundTextThemeColor(),
                  ),
                  child: Text(
                    '1M',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '2M',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '6M',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '1Y',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ALL',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: AllCoustomTheme.getTextThemeColors(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            isLoadingSliderDetail
                ? Shimmer.fromColors(
                    baseColor: globals.buttoncolor1,
                    highlightColor: globals.buttoncolor2,
                    enabled: true,
                    child: Column(
                      children: [1, 1, 1, 1]
                          .map(
                            (_) => Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                                            ),
                                            Container(
                                              width: 40.0,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Market Cap',
                            style: TextStyle(
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          Text(
                            '\$' + double.parse(widget.marketCap).toStringAsFixed(2),
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: AllCoustomTheme.getTextThemeColors(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Volume 24hr',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$' + double.parse(widget.volume).toStringAsFixed(2),
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: AllCoustomTheme.getTextThemeColors(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Available Supply',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$' + double.parse(widget.availableSupply).toStringAsFixed(2),
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: AllCoustomTheme.getTextThemeColors(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '% Change 24hr',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.changein24HR.contains('-')
                                ? '' + double.parse(widget.changein24HR).toStringAsFixed(2) + '%'
                                : '+' + double.parse(widget.changein24HR).toStringAsFixed(2) + '%',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: widget.changein24HR.contains('-') ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: AllCoustomTheme.getsecoundTextThemeColor(),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
