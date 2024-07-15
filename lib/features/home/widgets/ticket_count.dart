import 'package:flutter/material.dart';

class TicketCount extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  TicketCount({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => onChanged(count - 1),
        ),
        Text(count.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onChanged(count + 1),
        ),
      ],
    );
  }
}
