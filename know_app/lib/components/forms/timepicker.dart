import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) SetTime;
  const TimePicker(this.SetTime, {super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);
  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return Row(children: [
      Text(
        '$hours : $minutes',
        style: const TextStyle(fontSize: 32),
      ),
      ElevatedButton(
          onPressed: () async {
            TimeOfDay? newTime =
                await showTimePicker(context: context, initialTime: time);
            if (newTime == null) return;
            setState(() {
              time = newTime;
            });
            widget.SetTime(time);
          },
          child: const Text("Select Time"))
    ]);
  }
}
