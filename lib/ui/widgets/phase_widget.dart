import 'package:flow_fusion/enums/PhaseType.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flutter/material.dart';

class PhaseWidget extends StatefulWidget {
  final Phase phase;
  const PhaseWidget({
    Key? key,
    required this.phase,
  }) : super(key: key);

  @override
  State<PhaseWidget> createState() => _PhaseWidgetState();
}

class _PhaseWidgetState extends State<PhaseWidget> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phase.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateName() {
    setState(() {
      widget.phase.name = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.phase.type == PhaseType.work
                  ? Colors.red
                  : Colors.green),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Phase Name',
            ),
            onChanged: (value) => _updateName(),
            maxLines: 1,
            maxLength: 15,
          ),
          const SizedBox(width: 8.0),
          Text('${widget.phase.duration}'),
        ]));
  }
}
