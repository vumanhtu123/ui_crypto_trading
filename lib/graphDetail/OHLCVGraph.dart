// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';

class OHLCVGraph extends StatelessWidget {
  OHLCVGraph({
    key,
    required this.data,
    this.lineWidth = 1.0,
    this.fallbackHeight = 100.0,
    this.fallbackWidth = 300.0,
    this.gridLineColor = Colors.grey,
    this.gridLineAmount = 5,
    this.gridLineWidth = 0.5,
    this.gridLineLabelColor = Colors.grey,
    this.labelPrefix = "\$",
    required this.enableGridLines,
    required this.volumeProp,
    this.increaseColor = Colors.green,
    this.decreaseColor = Colors.red,
  })  : assert(data != null),
        super(key: key);

  final List data;

  final double lineWidth;

  final bool enableGridLines;
  final Color gridLineColor;
  final Color gridLineLabelColor;

  final int gridLineAmount;

  /// Width of grid lines
  final double gridLineWidth;

  final double volumeProp;

  final double fallbackHeight;
  final double fallbackWidth;

  final String labelPrefix;

  final Color increaseColor;

  final Color decreaseColor;

  @override
  Widget build(BuildContext context) {
    return new LimitedBox(
      maxHeight: fallbackHeight,
      maxWidth: fallbackWidth,
      child: new CustomPaint(
        size: Size.infinite,
        painter: new _OHLCVPainter(
          data,
          lineWidth: lineWidth,
          gridLineColor: gridLineColor,
          gridLineAmount: gridLineAmount,
          gridLineWidth: gridLineWidth,
          gridLineLabelColor: gridLineLabelColor,
          enableGridLines: enableGridLines,
          volumeProp: volumeProp,
          labelPrefix: labelPrefix,
          increaseColor: increaseColor,
          decreaseColor: decreaseColor,
        ),
      ),
    );
  }
}

class _OHLCVPainter extends CustomPainter {
  _OHLCVPainter(
    this.data, {
    required this.lineWidth,
    required this.enableGridLines,
    required this.gridLineColor,
    required this.gridLineAmount,
    required this.gridLineWidth,
    required this.gridLineLabelColor,
    required this.volumeProp,
    required this.labelPrefix,
    required this.increaseColor,
    required this.decreaseColor,
  });

  final List? data;
  final double lineWidth;
  final bool enableGridLines;
  final Color gridLineColor;
  final int gridLineAmount;
  final double gridLineWidth;
  final Color gridLineLabelColor;
  final String labelPrefix;
  final double volumeProp;
  final Color increaseColor;
  final Color decreaseColor;

  double _min = 0;
  double _max = 0;
  double _maxVolume = 0;

  List<TextPainter> gridLineTextPainters = [];
  late TextPainter maxVolumePainter;

  numCommaParse(number) {
    return number.round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }

  update() {
    _min = double.infinity;
    _max = -double.infinity;
    _maxVolume = -double.infinity;
    for (var i in data!) {
      if (i["high"] > _max) {
        _max = i["high"].toDouble();
      }
      if (i["low"] < _min) {
        _min = i["low"].toDouble();
      }
      if (i["volumeto"] > _maxVolume) {
        _maxVolume = i["volumeto"].toDouble();
      }
    }

    if (enableGridLines) {
      double gridLineValue;
      for (int i = 0; i < gridLineAmount; i++) {
        gridLineValue = _max - (((_max - _min) / (gridLineAmount - 1)) * i);

        String gridLineText;
        if (gridLineValue < 1) {
          gridLineText = gridLineValue.toStringAsPrecision(4);
        } else if (gridLineValue < 999) {
          gridLineText = gridLineValue.toStringAsFixed(2);
        } else {
          gridLineText = gridLineValue.round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
        }

        gridLineTextPainters.add(new TextPainter(
            text: new TextSpan(
                text: labelPrefix + gridLineText, style: new TextStyle(color: gridLineLabelColor, fontSize: 10.0, fontWeight: FontWeight.bold)),
            textDirection: TextDirection.ltr));
        gridLineTextPainters[i].layout();
      }

      maxVolumePainter = new TextPainter(
          text: new TextSpan(
              text: "\$" + numCommaParse(_maxVolume), style: new TextStyle(color: gridLineLabelColor, fontSize: 10.0, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr);
      maxVolumePainter.layout();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_min == null || _max == null || _maxVolume == null) {
      update();
    }

    final double volumeHeight = size.height * volumeProp;
    final double volumeNormalizer = volumeHeight / _maxVolume;

    double width = size.width;
    final double height = size.height * (1 - volumeProp);

    if (enableGridLines) {
      width = size.width;
      Paint gridPaint = new Paint()
        ..color = gridLineColor
        ..strokeWidth = gridLineWidth;

      double gridLineDist = height / (gridLineAmount - 1);
      double gridLineY = 0;

      // Draw grid lines
      for (int i = 0; i < gridLineAmount; i++) {
        gridLineY = (gridLineDist * i).round().toDouble();
        canvas.drawLine(new Offset(0.0, gridLineY), new Offset(width, gridLineY), gridPaint);

        // Label grid lines
        gridLineTextPainters[i].paint(canvas, new Offset(width + 2.0, gridLineY - 6.0));
      }

      // Label volume line
      maxVolumePainter.paint(canvas, new Offset(0.0, gridLineY + 2.0));
    }

    final double heightNormalizer = height / (_max - _min);
    final double rectWidth = width / data!.length;

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    // Loop through all data
    for (int i = 0; i < data!.length; i++) {
      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2;

      double volumeBarTop = (height + volumeHeight) - (data![i]["volumeto"] * volumeNormalizer - lineWidth / 2);
      double volumeBarBottom = height + volumeHeight + lineWidth / 2;

      if (data![i]["open"] > data![i]["close"]) {
        // Draw candlestick if decrease
        rectTop = height - (data![i]["open"] - _min) * heightNormalizer;
        rectBottom = height - (data![i]["close"] - _min) * heightNormalizer;
        rectPaint = new Paint()
          ..color = decreaseColor
          ..strokeWidth = lineWidth;

        Rect ocRect = new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
        canvas.drawRect(ocRect, rectPaint);

        // Draw volume bars
        Rect volumeRect = new Rect.fromLTRB(rectLeft, volumeBarTop, rectRight, volumeBarBottom);
        canvas.drawRect(volumeRect, rectPaint);
      } else {
        // Draw candlestick if increase
        rectTop = (height - (data![i]["close"] - _min) * heightNormalizer) + lineWidth / 2;
        rectBottom = (height - (data![i]["open"] - _min) * heightNormalizer) - lineWidth / 2;
        rectPaint = new Paint()
          ..color = increaseColor
          ..strokeWidth = lineWidth;

        canvas.drawLine(new Offset(rectLeft, rectBottom - lineWidth / 2), new Offset(rectRight, rectBottom - lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft, rectTop + lineWidth / 2), new Offset(rectRight, rectTop + lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft + lineWidth / 2, rectBottom), new Offset(rectLeft + lineWidth / 2, rectTop), rectPaint);
        canvas.drawLine(new Offset(rectRight - lineWidth / 2, rectBottom), new Offset(rectRight - lineWidth / 2, rectTop), rectPaint);

        // Draw volume bars
        canvas.drawLine(new Offset(rectLeft, volumeBarBottom - lineWidth / 2), new Offset(rectRight, volumeBarBottom - lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft, volumeBarTop + lineWidth / 2), new Offset(rectRight, volumeBarTop + lineWidth / 2), rectPaint);
        canvas.drawLine(new Offset(rectLeft + lineWidth / 2, volumeBarBottom), new Offset(rectLeft + lineWidth / 2, volumeBarTop), rectPaint);
        canvas.drawLine(new Offset(rectRight - lineWidth / 2, volumeBarBottom), new Offset(rectRight - lineWidth / 2, volumeBarTop), rectPaint);
      }

      // Draw low/high candlestick wicks
      double low = height - (data![i]["low"] - _min) * heightNormalizer;
      double high = height - (data![i]["high"] - _min) * heightNormalizer;
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectBottom), new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low), rectPaint);
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectTop), new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high), rectPaint);
    }
  }

  @override
  bool shouldRepaint(_OHLCVPainter old) {
    return data != old.data ||
        lineWidth != old.lineWidth ||
        enableGridLines != old.enableGridLines ||
        gridLineColor != old.gridLineColor ||
        gridLineAmount != old.gridLineAmount ||
        gridLineWidth != old.gridLineWidth ||
        volumeProp != old.volumeProp ||
        gridLineLabelColor != old.gridLineLabelColor;
  }
}
