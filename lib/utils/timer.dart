import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final Function onTimerFinished;

  const CountdownTimer({
    Key? key,
    required this.seconds,
    required this.onTimerFinished,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          widget.onTimerFinished();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('high-score').snapshots(),
        builder: (context, snapshot) {
          return Row(
            children: [
              Icon(Icons.alarm,
                  color: _remainingSeconds < 10 ? Colors.red : Colors.black),
              const SizedBox(width: 10),
              Text(
                "$_remainingSeconds sec",
                style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    color: _remainingSeconds < 10 ? Colors.red : Colors.black),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
