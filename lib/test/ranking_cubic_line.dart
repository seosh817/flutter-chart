import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/res/colors.dart';
import 'package:flutter_chart/state/action_state.dart';
import 'package:flutter_chart/test/marker/cubic_line_marker.dart';
import 'package:flutter_chart/util.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/line_data_provider.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/legend_direction.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/fill_formatter/i_fill_formatter.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';
import 'package:mp_chart/mp/core/value_formatter/default_value_formatter.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

class RankingCubicLineChart extends StatefulWidget {

  static const routeName = "/test/ranking_cubic_line";

  const RankingCubicLineChart({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RankingCubicLineChartState();
}

class _RankingCubicLineChartState extends State<RankingCubicLineChart> {
  LineChartController controller;
  var random = Random(1);
  int _count = 7;
  double _range = 100;

  @override
  void initState() {
    _initController();
    _initLineData(_count, _range);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Cubic Line")
      ),
      body: Container(
        width: 328,
        height: 200,
        child: _initLineChart(),
      ),
    );
  }


  // @override
  // Widget getBody() {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: 328,
  //         height: 200,
  //         child: Container(
  //           color: Colors.blue,
  //         ),
  //       ),
  //       Container(
  //         width: 328,
  //         height: 200,
  //         child: _initLineChart(),
  //       )
  //     ],
  //   );
  // }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..typeface = Util.BOLD
            ..setLabelCount2(5, false)
            ..textColor = Colours.mango
            ..position = YAxisLabelPosition.INSIDE_CHART
            ..drawGridLines = (false)
            ..drawLabels = false
            ..axisLineColor = (ColorUtils.WHITE);
          //..drawLabels = false
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = false;
        },
        legendSettingFunction: (legend, controller) {
          (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
          legend.enabled = (true);
          legend.textColor = Colors.white;
          // legend.direction = LegendDirection.LEFT_TO_RIGHT;
          // legend.orientation = LegendOrientation.VERTICAL;

          var data = (controller as LineChartController).data;
          if (data != null) {
            var formatter = data.getDataSetByIndex(0).getFillFormatter();
            if (formatter is FillFormatter) {
              formatter.setPainter(controller);
            }
          }
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..enabled = (true)
            ..position = (XAxisPosition.BOTTOM)
//        ..setTypeface(tfLight)
            ..textSize = (10)
            ..textColor = (ColorUtils.WHITE)
            ..drawAxisLine = (false)
            ..drawGridLines = false
          // ..drawGridLines = (true)
            ..textColor = (Color.fromARGB(255, 255, 192, 56))
            ..centerAxisLabels = (true)
            ..setGranularity(1)
            ..avoidFirstLastClipping = true
            ..setValueFormatter(A());
        },
        minOffset: 100.0,
        extraLeftOffset: 10.0,
        extraRightOffset: 10.0,
        drawGridBackground: true,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        marker: CubicLineMarker(),
        // gridBackColor: Color.fromARGB(255, 249, 168, 37),
        backgroundColor: Colours.warm_blue,
        gridBackColor: Colours.warm_blue,
        description: desc);
  }

  Widget _initLineChart() {
    var lineChart = LineChart(controller);
    controller.animator
      ..reset()
      ..animateXY1(2000, 2000);
    return lineChart;
  }

  void _initLineData(int count, double range) async {
    List<Entry> values = List();

    for (int i = 0; i < count; i++) {
      double val = (random.nextDouble() * (range));
      values.add(Entry(x: i.toDouble(), y: val));
    }

    LineDataSet concentrateSet;

    concentrateSet = LineDataSet(values, "집중도");

    // concentrateSet.getCubicIntensity();
    concentrateSet.setMode(Mode.CUBIC_BEZIER);
    concentrateSet.setCubicIntensity(0.2);
    concentrateSet.setDrawFilled(false);
    concentrateSet.setDrawCircles(false);
    concentrateSet.setColor1(Colours.mango);
    concentrateSet.setFillColor(Colors.transparent);
    concentrateSet.setFillAlpha(100);
    concentrateSet.setDrawHorizontalHighlightIndicator(false);
    concentrateSet.setLineWidth(4.0);

    //highlight
    concentrateSet.setHighLightColor(Colours.mango);
    concentrateSet.setDrawVerticalHighlightIndicator(false);
    concentrateSet.setDrawHorizontalHighlightIndicator(true);
    concentrateSet.highlightDashPathEffect = DashPathEffect(5.0, 5.0, 0);
    concentrateSet.setHighlightLineWidth(1.5);

    controller.data = LineData.fromList(List()..add(concentrateSet))
      ..setValueTypeface(Util.NOTO_LIGHT)
      ..setValueTextSize(9)
      ..setDrawValues(false);

    setState(() {});
  }


}

final List<String> days = List()
  ..add("월")
  ..add("화")
  ..add("수")
  ..add("목")
  ..add("금")
  ..add("토")
  ..add("일");

class A extends ValueFormatter {
  @override
  String getFormattedValue1(double value) {
    return days[value.toInt() % days.length];
  }
}

class FillFormatter implements IFillFormatter {
  LineChartController _controller;

  void setPainter(LineChartController controller) {
    _controller = controller;
  }

  @override
  double getFillLinePosition(
      ILineDataSet dataSet, LineDataProvider dataProvider) {
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}
