
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Timer/timer_page.dart';
import 'package:flutter_application_1/Screens/library.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

class LearnDesk extends StatelessWidget {
  const LearnDesk({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationBarBottom(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Learn Desk",
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
                const Library(),
              ),
              _learndeskContainerRowMethod(
                context,
                const AssetImage('assets/flashcards.png'),
                'Create Flashcards',
                const Library(),
                const AssetImage('assets/help.png'),
                'Request Tution',
                const Library(),
              ),

              _learndeskContainerRowMethod(
                context,
                const AssetImage('assets/target.png'),
                'Set Goals',
                const Library(),
                const AssetImage('assets/quize.png'),
                'Quizes',
                const Library(),
              ),
            ],
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
  return Container(
    color: Colors.white,
    height: 230,
    width: 400,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
//first icon start

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => linkedPage1,
              ),
            );
          },
          child: Container(
            width: 180,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(
                    image: containerImage1,
                    width: 120,
                    height: 120,
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.grey[400],
                  ),
                  child: Center(
                    child: Text(
                      containerTopic1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

//first icon stopped and second icon started

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => linkedPage2,
              ),
            );
          },
          child: Container(
            width: 180,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(
                    image: containerImage2,
                    width: 120,
                    height: 120,
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.grey[400],
                  ),
                  child: Center(
                    child: Text(
                      containerTopic2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
