import 'package:LearnPro/Flashcards/screen/content_form.dart';

import 'package:LearnPro/Screens/setGoals/set_goals.dart';
import 'package:LearnPro/Screens/upload_pdf_page.dart';
import 'package:LearnPro/tutoring_system/learning_information.dart';

import 'package:flutter/material.dart';
import 'package:LearnPro/Screens/Timer/timer_page.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';

class LearnDesk extends StatelessWidget {
  const LearnDesk({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarBottom()),
        );
        return false; // Prevent the default back button behavior
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Learn Desk",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                //Learn Desk Container Row Method calling

                _learndeskContainerRowMethod(
                    context,
                    const AssetImage('assets/clock.png'),
                    'Focus Timer',
                    const TimerScreen(),
                    const AssetImage('assets/cloud.png'),
                    'Upload Notes',
                    const UploadPdfPage()),
                _learndeskContainerRowMethod(
                  context,
                  const AssetImage('assets/flashcards.png'),
                  'Create Flashcards',
                  const ContentForm(),
                  const AssetImage('assets/boy.png'),
                  'Records',
                  const LearningInformation(),
                ),

                _learndeskContainerRowMethod(
                  context,
                  const AssetImage('assets/target.png'),
                  'Set Goals',
                  SetGoals(),
                  const AssetImage('assets/quiz.png'),
                  'Quizes',
                  const NavigationBarBottom(
                      initialIndex: 1, learningTabBarIndex: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Learn Desk Container Row Method

Widget _learndeskContainerRowMethod(
  BuildContext context,
  ImageProvider<Object> containerImage1,
  String containerTopic1,
  Widget linkedPage1,
  ImageProvider<Object> containerImage2,
  String containerTopic2,
  Widget linkedPage2,
) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = (screenWidth / 2) - 24; // Adjust as needed

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // First icon start
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => linkedPage1,
              ),
            );
          },
          child: Container(
            width: containerWidth,
            // height: 200,
            height: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(
                    image: containerImage1,
                    width: 90,
                    height: 90,
                    // width: 120,
                    // height: 120,
                  ),
                ),
                Container(
                  // height: 50,
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      containerTopic1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Second icon start
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => linkedPage2,
              ),
            );
          },
          child: Container(
            width: containerWidth,
            height: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(
                    image: containerImage2,
                    width: 90,
                    height: 90,
                    // width: 120,
                    // height: 120,
                  ),
                ),
                Container(
                  // height: 50
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      containerTopic2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
