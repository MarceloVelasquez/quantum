import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/src/models/output_model.dart';

class SectionGraphics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataChart = Provider.of<OutputModel>(context, listen: false).dataChart;

    Series<DataChart, String> serie = Series(
      id: 'Datos',
      data: dataChart,
      colorFn: (_, __) => MaterialPalette.red.shadeDefault,
      domainFn: (data, _) => data.string,
      measureFn: (data, _) => data.value,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Gráfico de procesos'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 50),
          child: BarChart(
            [serie],
            animationDuration: Duration(seconds: 1),
            domainAxis: OrdinalAxisSpec(
              showAxisLine: true,
              renderSpec: NoneRenderSpec(),
            ),
          ),
        ),
      ),
    );
  }
}
