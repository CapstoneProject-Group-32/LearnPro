// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:LearnPro/Controllers/history_controller.dart';
// import 'package:LearnPro/Screens/Timer/history_page.dart';

// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:LearnPro/models/timer_history_model.dart';

// class TimerScreen extends StatefulWidget {
//   const TimerScreen({Key? key}) : super(key: key);

//   @override
//   _TimerScreenState createState() => _TimerScreenState();
// }

// class _TimerScreenState extends State<TimerScreen> {
//   double defaultValue = 1500;
//   double value = 1500.0;
//   bool isStarted = false;
//   int focusedMins = 0;
//   List<History> listHistory = [];
//   late Timer _timer = Timer(Duration.zero, () {});
//   HistoryController historyController = HistoryController();
//   User? user = FirebaseAuth.instance.currentUser; // Get the current user

//   void startTimer() {
//     focusedMins = value.toInt();
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (value <= 1) {
//           setState(() {
//             timer.cancel();
//             value = defaultValue;
//             isStarted = false;
//             History history =
//                 History(dateTime: DateTime.now(), focusedSecs: focusedMins);
//             historyController.saveFocusTime(
//                 user!.uid, history); // Save to Firestore
//             listHistory.add(history);
//           });
//         } else {
//           setState(() {
//             value--;
//           });
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: const Text(
//           "Timer",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 20,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HistoryScreen(),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.history,
//               size: 20,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 50,
//             ),
//             const Text(
//               "Start a Focus session",
//               style: TextStyle(fontSize: 20),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   Center(
//                     child: SizedBox(
//                       width: 250,
//                       height: 250,
//                       child: Stack(
//                         children: [
//                           SleekCircularSlider(
//                             initialValue: value,
//                             min: 0,
//                             max: 3601,
//                             appearance: CircularSliderAppearance(
//                               customWidths: CustomSliderWidths(
//                                 trackWidth: 6,
//                                 handlerSize: 15,
//                                 progressBarWidth: 10,
//                                 shadowWidth: 0,
//                               ),
//                               customColors: CustomSliderColors(
//                                 trackColor:
//                                     Theme.of(context).colorScheme.primary,
//                                 progressBarColor:
//                                     Theme.of(context).colorScheme.secondary,
//                                 hideShadow: true,
//                                 dotColor:
//                                     Theme.of(context).colorScheme.secondary,
//                               ),
//                               size: 250,
//                               angleRange: 360,
//                               startAngle: 270,
//                             ),
//                             onChange: (newValue) {
//                               setState(() {
//                                 value = newValue;
//                               });
//                             },
//                             innerWidget: (double newValue) {
//                               return Center(
//                                 child: Text(
//                                   "${(value ~/ 60).toInt().toString().padLeft(2, '0')}:${(value % 60).toInt().toString().padLeft(2, '0')}",
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 46,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           if (isStarted)
//                             GestureDetector(
//                               onTap: () {},
//                               child: Container(
//                                 width: 250,
//                                 height: 250,
//                                 color: Colors.transparent,
//                               ),
//                             )
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 100,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (!isStarted) {
//                           isStarted = true;
//                           startTimer();
//                         } else {
//                           _timer.cancel();
//                           value = defaultValue;
//                           isStarted = false;
//                         }
//                       });
//                     },
//                     child: Container(
//                       width: 200,
//                       height: 50,
//                       decoration: ShapeDecoration(
//                         color: Theme.of(context).colorScheme.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(35),
//                         ),
//                         shadows: const [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           )
//                         ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           isStarted ? "STOP" : "START",
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontFamily: 'Work Sans',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:LearnPro/Controllers/history_controller.dart';
import 'package:LearnPro/Screens/Timer/history_page.dart';

import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:LearnPro/models/timer_history_model.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  double defaultValue = 1500;
  double value = 1500.0;
  bool isStarted = false;
  int focusedMins = 0;
  List<History> listHistory = [];
  late Timer _timer = Timer(Duration.zero, () {});
  HistoryController historyController = HistoryController();
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  void startTimer() {
    focusedMins = value.toInt();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (value <= 1) {
          setState(() {
            timer.cancel();
            value = defaultValue;
            isStarted = false;
            History history =
                History(dateTime: DateTime.now(), focusedSecs: focusedMins);
            historyController.saveFocusTime(
                user!.uid, history); // Save to Firestore
            listHistory.add(history);
          });
        } else {
          setState(() {
            value--;
          });
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (isStarted) {
      bool? result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content:
              const Text('Do you want to exit without saving your progress?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      return result ?? false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            "Timer",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () async {
              if (isStarted) {
                bool? result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'Do you want to exit without saving your progress?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.history,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Start a Focus session",
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          children: [
                            SleekCircularSlider(
                              initialValue: value,
                              min: 0,
                              max: 3601,
                              appearance: CircularSliderAppearance(
                                customWidths: CustomSliderWidths(
                                  trackWidth: 6,
                                  handlerSize: 15,
                                  progressBarWidth: 10,
                                  shadowWidth: 0,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor:
                                      Theme.of(context).colorScheme.primary,
                                  progressBarColor:
                                      Theme.of(context).colorScheme.secondary,
                                  hideShadow: true,
                                  dotColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                size: 250,
                                angleRange: 360,
                                startAngle: 270,
                              ),
                              onChange: (newValue) {
                                setState(() {
                                  value = newValue;
                                });
                              },
                              innerWidget: (double newValue) {
                                return Center(
                                  child: Text(
                                    "${(value ~/ 60).toInt().toString().padLeft(2, '0')}:${(value % 60).toInt().toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 46,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (isStarted)
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  color: Colors.transparent,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isStarted) {
                            isStarted = true;
                            startTimer();
                          } else {
                            _timer.cancel();
                            value = defaultValue;
                            isStarted = false;
                          }
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isStarted ? "STOP" : "START",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
