import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remainders/constants/colors.dart';
import 'package:remainders/main.dart';

class Item extends StatefulWidget {
  final Remainder remainder;
  final Function toggle;
  const Item({super.key, required this.remainder, required this.toggle});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final Random random = Random();
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = pleasantColors[random.nextInt(pleasantColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    bool completed = widget.remainder.completed;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              widget.toggle(widget.remainder.id);
            },
            child: Icon(
              completed ? Icons.check_circle : Icons.circle_outlined,
              color: _color,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.remainder.title,
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
