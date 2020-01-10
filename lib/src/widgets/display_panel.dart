import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/structure_model.dart';
import 'package:quantum/src/pages/section_structure.dart';

enum TraceState { created, empty, process, finish }

class DisplayPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<StructureModel>(context);
    TraceState state = TraceState.created;
    var child;

    if (model.actualTrace != null) {
      state = model.actualTrace.isEmpty ? TraceState.empty : TraceState.process;
      if (model.isDone) state = TraceState.finish;
    }

    switch (state) {
      case TraceState.created:
        child = Center(child: Text('Presiona para continuar'));
        break;
      case TraceState.empty:
        child = Center(child: Text('Tiempo muerto'));
        break;
      case TraceState.process:
        child = _PanelTrace(trace: model.actualTrace);
        break;
      case TraceState.finish:
        child = Center(child: Text('Completado'));
        break;
      default:
    }

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).cursorColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: child,
      ),
      onTap: () => Provider.of<StructureModel>(context, listen: false).next(),
    );
  }
}

class _PanelTrace extends StatelessWidget {
  const _PanelTrace({Key key, @required this.trace}) : super(key: key);
  final Trace trace;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ProcessItem(id: trace.id),
          Container(
            margin: EdgeInsets.all(2),
            child: Text(trace.statusName),
          ),
          Container(
            margin: EdgeInsets.all(2),
            child: Text(trace.advance),
          ),
        ],
      ),
    );
  }
}
