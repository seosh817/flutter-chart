import 'package:flutter/material.dart';
import 'package:flutter_chart/res/resources.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';

class WhiteMarker implements IMarker {

  Entry _entry;

  double _dx = 0.0;
  double _dy = -10.0;

  Color _firstTextColor;
  Color _secondTextColor;
  Color _backgroundColor;
  double _fontSize;


  WhiteMarker({Color firstTextColor, Color secondTextColor, Color backgroundColor, double fontSize})
      : _firstTextColor = firstTextColor,
        _secondTextColor = secondTextColor,
        _backgroundColor = backgroundColor,
        _fontSize = fontSize {
    this._firstTextColor ??= Colors.white;
    this._secondTextColor ??= Colours.mango;
    this._backgroundColor ??= Colours.azul;
    this._fontSize ??= Utils.convertDpToPixel(10.0);
  }

  @override
  void draw(Canvas canvas, double posX, double posY) {
    TextPainter painter = PainterUtils.create(null, "${_entry.y.toInt()}위", _secondTextColor, _fontSize);
    Paint paint = Paint()
      ..color = _backgroundColor
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    MPPointF offset = getOffsetForDrawingAtPoint(posX, posY);

    canvas.save();
    // translate to the correct position and draw
    canvas.translate(offset.x, offset.y);
    painter.layout();
    Offset pos = calculatePos(
        posX + offset.x, posY + offset.y, painter.width, painter.height);
    canvas.drawRRect(
        RRect.fromLTRBR(pos.dx - 5, pos.dy - 5, pos.dx + painter.width + 5,
            pos.dy + painter.height + 5, Radius.circular(5)),
        paint);
    painter.paint(canvas, pos);
    canvas.restore();
  }

  Offset calculatePos(double posX, double posY, double textW, double textH) {
    return Offset(posX - textW / 2, posY - textH / 2);
  }

  @override
  MPPointF getOffset() {
    return MPPointF.getInstance1(_dx, _dy);
  }

  @override
  MPPointF getOffsetForDrawingAtPoint(double posX, double posY) {
    return getOffset();
  }

  @override
  void refreshContent(Entry e, Highlight highlight) {
    _entry = e;
  }

}