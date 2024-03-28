import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final Function(DateTime)? onStartDateSelected;
  final Function(DateTime)? onEndDateSelected;

  const DateFilter({
    Key? key,
    this.onStartDateSelected,
    this.onEndDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onStartDateSelected != null) {
              onStartDateSelected!(selectedDate);
            }
          },
          child: const Text('Start Date'),
        ),
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onEndDateSelected != null) {
              onEndDateSelected!(selectedDate);
            }
          },
          child: const Text('End Date'),
        ),
      ],
    );
  }
}
