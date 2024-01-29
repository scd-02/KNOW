import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController _dateController;
  const DatePicker(this._dateController, {super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        widget._dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextField(
      controller: widget._dateController,
      decoration: const InputDecoration(
          labelText: 'DATE',
          filled: true,
          prefixIcon: Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
      readOnly: true,
      onTap: () {
        _selectDate();
      },
    ));
  }
}
