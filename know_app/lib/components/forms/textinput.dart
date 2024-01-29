import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final TextEditingController textInputController;
  final String placeHolder;
  const TextInput(this.textInputController, this.placeHolder, {super.key});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.textInputController,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: widget.placeHolder),
      ),
    );
  }
}
