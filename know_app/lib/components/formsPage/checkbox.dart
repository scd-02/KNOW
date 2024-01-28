import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final Function(bool?) SetCheck;
  const CheckBox(this.SetCheck, {super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Checkbox(
          activeColor: Colors.orangeAccent,
          value: isChecked,
          onChanged: (newBool) {
            setState(() {
              isChecked = newBool;
            });
            widget.SetCheck(isChecked);
          }),
    );
  }
}
