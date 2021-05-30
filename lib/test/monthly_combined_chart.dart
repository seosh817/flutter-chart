import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/res/colors.dart';
import 'package:flutter_chart/test/marker/cubic_line_marker.dart';
import 'package:flutter_chart/util.dart';
import 'package:mp_chart/mp/chart/combined_chart.dart';
import 'package:mp_chart/mp/controller/combined_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data/combined_data.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/legend_horizontal_alignment.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:mp_chart/mp/painter/combined_chart_painter.dart';

class MonthlyCombinedChart extends StatefulWidget {
  static const routeName = "/test/monthly_combined";

  @override
  State<StatefulWidget> createState() {
    return MonthlyCombinedChartState();
  }
}

class MonthlyCombinedChartState extends State<MonthlyCombinedChart> {
  CombinedChartController controller;
  int _count = 5;
  var random = Random(1);

  @override
  void initState() {
    _initController();
    _initCombinedData();
    super.initState();
  }

  Widget _initCombinedChart() {
    var combinedChart = CombinedChart(controller);
    controller.animator
      ..reset()
      ..animateXY1(2000, 2000);
    return combinedChart;
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = CombinedChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..drawGridLines = (false)
            ..setAxisMinimum(0)
            ..drawZeroLine = true
            ..drawAxisLine = false
            ..drawLabels = false;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..drawGridLines = (false)
            ..setAxisMinimum(0)
            ..drawAxisLine = false
            ..drawLabels = false;
        },
        legendSettingFunction: (legend, controller) {
          legend
            ..wordWrapEnabled = (true)
            ..verticalAlignment = (LegendVerticalAlignment.BOTTOM)
            ..horizontalAlignment = (LegendHorizontalAlignment.CENTER)
            ..orientation = (LegendOrientation.HORIZONTAL)
            ..drawInside = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..position = (XAxisPosition.BOTH_SIDED)
            ..setAxisMinimum(0)
            ..setGranularity(1)
            ..setValueFormatter(A())
            ..drawGridLines = false
            ..drawGridLinesBehindData = false
            ..drawAxisLine = false
          // ..drawLabels = false
            ..setAxisMaximum(
                controller.data == null ? 0 : controller.data.xMax + 0.25);
        },
        drawGridBackground: false,
        drawBarShadow: false,
        highlightFullBarEnabled: false,
        dragXEnabled: true,
        dragYEnabled: true,
        drawBorders: false,
        drawValueAboveBar: false,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        marker: CubicLineMarker(),
        maxVisibleCount: 60,
        backgroundColor: Colours.warm_blue,
        description: desc,
        drawOrder: List()..add(DrawOrder.BAR)..add(DrawOrder.LINE));
  }

  void _initCombinedData() {
    controller.data = CombinedData();
    controller.data
      ..setData1(generateLineData())
      ..setData2(generateBarData())
      ..setValueTypeface(Util.LIGHT);
  }

  double getRandom(double range, double start) {
    return (random.nextDouble() * range) + start;
  }

  LineData generateLineData() {
    LineData d = LineData();

    List<Entry> entries = List();

    for (int index = 0; index < _count; index++)
      entries.add(Entry(x: index.toDouble(), y: getRandom(15, 0)));

    LineDataSet set = LineDataSet(entries, "Line DataSet");
    set.setColor1(Colours.mango);
    set.setLineWidth(4.0);
    set.setDrawCircles(false);
    set.setMode(Mode.CUBIC_BEZIER);
    set.setDrawValues(false);

    //highlight
    set.setHighLightColor(Colours.mango);
    set.setDrawVerticalHighlightIndicator(false);
    set.setDrawHorizontalHighlightIndicator(true);
    set.highlightDashPathEffect = DashPathEffect(5.0, 5.0, 0);
    set.setHighlightLineWidth(1.5);

    // set.setValueTextSize(10);
    // set.setValueTextColor(Color.fromARGB(255, 240, 238, 70));
    // set.setCircleColor(Color.fromARGB(255, 240, 238, 70));
    // set.setCircleRadius(0);
    // set.setFillColor(Color.fromARGB(255, 240, 238, 70));

    set.setAxisDependency(AxisDependency.LEFT);
    d.addDataSet(set);

    return d;
  }

  BarData generateBarData() {
    List<BarEntry> entries1 = List();

    for (int index = 0; index < _count; index++) {
      entries1.add(BarEntry(x: index.toDouble(), y: getRandom(15, 0)));
    }

    BarDataSet set1 = BarDataSet(entries1, "Bar 1");
    set1.setColor1(Colors.white);
    set1.setAxisDependency(AxisDependency.LEFT);
    set1.setDrawValues(false);
    set1.setHighLightColor(Colours.pastel_blue);

    //highlight
    set1.setFormLineDashEffect(DashPathEffect(5.0, 5.0, 0));
    set1.setHighLightColor(Colours.pastel_blue);

    List<IBarDataSet> dataSets = List();
    dataSets.add(set1);

    BarData data = BarData(dataSets);
    data.barWidth = 0.5;
    // BarData d = BarData(List()..add(set1));

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monthly Combined"),
      ),
      body: Container(
        width: 328,
        height: 200,
        child: _initCombinedChart(),
      ),
    );
  }
}

final List<String> weeks = List()..add("1주")..add("2주")..add("3주")..add("4주");

class A extends ValueFormatter {
  @override
  String getFormattedValue1(double value) {
    return weeks[value.toInt() % weeks.length];
  }
}
