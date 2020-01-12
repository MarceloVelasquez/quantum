import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/structure_model.dart';
import 'package:quantum/src/models/output_model.dart';
import 'package:quantum/src/widgets/panels.dart';

class SectionStructure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var traces = Provider.of<OutputModel>(context).traces;

    return ChangeNotifierProvider(
      create: (context) => StructureModel(traces),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Estructura de datos'),
        ),
        body: Container(
          padding: EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: DisplayPanel(),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.newed),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.ready),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.inAction),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.locked),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.suspended),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.lost),
              ),
              Expanded(
                flex: 1,
                child: StructureItem(status: Status.finished),
              ),
              Expanded(
                flex: 1,
                child: TapPanel(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StructureItem extends StatelessWidget {
  const StructureItem({Key key, @required this.status}) : super(key: key);

  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(StatusName[status]),
          Consumer<StructureModel>(
            builder: (_, model, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: model.structures[status]
                    .map((id) => ProcessItem(id: id))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProcessItem extends StatelessWidget {
  const ProcessItem({Key key, @required this.id}) : super(key: key);

  final int id;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).textTheme.caption.color,
          ),
          child: Center(
            child: Text(id.toString(), style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
