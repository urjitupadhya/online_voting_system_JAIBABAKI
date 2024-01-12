import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;

  const NumberPicker({
    Key? key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.onChanged?.call(int.tryParse(value) ?? widget.value);
          },
        ),
        Slider(
          value: widget.value.toDouble(),
          min: widget.minValue.toDouble(),
          max: widget.maxValue.toDouble(),
          onChanged: (value) {
            widget.onChanged?.call(value.round());
            _controller.text = value.round().toString();
          },
        ),
      ],
    );
  }
}
