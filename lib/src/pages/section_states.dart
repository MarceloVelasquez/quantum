import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/output_model.dart';

double tileSize = 40;

class SectionStates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var quantums = Provider.of<OutputModel>(context).quantums;
    var titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Theme.of(context).typography.dense.subhead.fontSize,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Center(child: Text('Process', style: titleStyle)),
              ),
              Expanded(
                child: Center(child: Text('Advance', style: titleStyle)),
              ),
              Expanded(
                child: Center(child: Text('State', style: titleStyle)),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: quantums.length,
        itemBuilder: (context, index) {
          return QuantumItem(
            traces: quantums[index].traces,
          );
        },
      ),
    );
  }
}

class QuantumItem extends StatelessWidget {
  const QuantumItem({Key key, @required this.traces}) : super(key: key);

  final List<Trace> traces;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tileSize * traces.length.toDouble(),
      child: Column(
        children: traces
            .map(
              (Trace trace) => Flexible(
                child: TraceItem(trace: trace),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TraceItem extends StatelessWidget {
  const TraceItem({Key key, this.trace}) : super(key: key);

  final Trace trace;

  @override
  Widget build(BuildContext context) {
    Widget traceWidget;

    if (trace.isEmpty) {
      traceWidget = Center(
        child: Text('Tiempo muerto'),
      );
    } else {
      traceWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('P'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(trace.process),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(child: Text(trace.advance)),
          ),
          Expanded(
            child: Center(child: Text(trace.status + trace.idBreak)),
          ),
        ],
      );
    }

    return Container(
      height: tileSize,
      child: traceWidget,
    );
    ;
  }
}
