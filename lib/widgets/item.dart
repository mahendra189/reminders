import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remainders/constants/colors.dart';

class Item extends StatefulWidget {
  final String title;
  const Item({super.key, required this.title});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final Random random = Random();
  late Color _color;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _color = pleasantColors[random.nextInt(pleasantColors.length)];
    // This assigns a color once and only when the widget is first created
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _completed = !_completed;
              });
            },
            child: Icon(
              _completed ? Icons.check_circle : Icons.circle_outlined,
              color: _color,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
