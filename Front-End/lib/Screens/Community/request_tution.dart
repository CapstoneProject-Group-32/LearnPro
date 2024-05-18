import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Screens/Community/find_studybuddies.dart';

class RequestTutionScreen extends StatefulWidget {
  const RequestTutionScreen({super.key});

  @override
  State<RequestTutionScreen> createState() => _RequestTutionScreenState();
}

class _RequestTutionScreenState extends State<RequestTutionScreen> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_updateDateText);
    _timeController.addListener(_updateTimeText);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _updateDateText() {
    final text = _dateController.text;
    if (text.length == 4 || text.length == 7) {
      if (text.length == 4 && !text.endsWith('-')) {
        _dateController.text = text + '-';
      } else if (text.length == 7 && !text.endsWith('-')) {
        _dateController.text = text + '-';
      }
      _dateController.selection = TextSelection.fromPosition(
        TextPosition(offset: _dateController.text.length),
      );
    }
  }

  void _updateTimeText() {
    final text = _timeController.text;
    if (text.length == 2) {
      if (!text.endsWith(':')) {
        _timeController.text = text + ':';
      }
      _timeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _timeController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Request Tution back button

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudyBuddies(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 28,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Request Tution",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //subject

                        TextFormField(
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Subject",
                            labelStyle: const TextStyle(
                              color: Color(0xFF16697A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF16697A),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        //Lesson or Theory

                        TextFormField(
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Lesson or Theory",
                            labelStyle: const TextStyle(
                              color: Color(0xFF16697A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF16697A),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Mention a available time period to arrange a meeting with your study buddy.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // Date
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: "Date",
                            labelStyle: const TextStyle(
                              color: Color(0xFF16697A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF16697A),
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|-')),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // Time
                        TextFormField(
                          controller: _timeController,
                          decoration: InputDecoration(
                            labelText: "Time",
                            labelStyle: const TextStyle(
                              color: Color(0xFF16697A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'HH:MM',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF16697A),
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|:')),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF29F6D2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                  child: const Center(
                                    child: Text(
                                      'Send',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'Work Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                  child: const Center(
                                    child: Text(
                                      'Cancle',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'Work Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}