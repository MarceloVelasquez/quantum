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
      child: ScaffoldStructure(),
    );
  }
}

class ScaffoldStructure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Estructura de datos'),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Column(
            children: Status.values
                .map((status) =>
                    SizedBox(height: 75, child: StructureItem(status: status)))
                .toList()
                  ..insert(0, SizedBox(height: 75, child: DisplayPanel())),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<StructureModel>(context, listen: false).next(),
        child: Icon(Icons.play_arrow),
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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(StatusName[status]),
          ),
          Expanded(
            child: Consumer<StructureModel>(
              builder: (_, model, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: model.structures[status].length,
                  itemBuilder: (context, index) {
                    return ProcessItem(id: model.structures[status][index]);
                  },
                );
              },
            ),
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
