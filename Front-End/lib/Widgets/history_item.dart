import 'package:flutter/material.dart';
import 'package:LearnPro/Models/timer_history_model.dart';

import 'package:intl/intl.dart';

class HistoryItem extends StatefulWidget {
  final History history;
  final bool isNewDay;
  const HistoryItem({super.key, required this.history, required this.isNewDay});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.isNewDay)
            Text(
              (widget.history.dateTime.day == today.day &&
                      widget.history.dateTime.month == today.month &&
                      widget.history.dateTime.year == today.year)
                  ? "Today"
                  : (widget.history.dateTime.day == (today.day - 1) &&
                          widget.history.dateTime.month == today.month &&
                          widget.history.dateTime.year == today.year)
                      ? "Yesterday"
                      : DateFormat('MM/dd/yyyy')
                          .format(widget.history.dateTime),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          if (widget.isNewDay)
            const SizedBox(
              height: 15,
            ),
          Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 115, 204, 245),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.16),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You have focused for",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${widget.history.focusedSecs <= 60 ? widget.history.focusedSecs.toInt() : (widget.history.focusedSecs ~/ 60).toInt()} ${widget.history.focusedSecs.toInt() <= 60 ? "Secs" : "Mins"}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Text(
                    DateFormat('hh:mm a').format(widget.history.dateTime),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
