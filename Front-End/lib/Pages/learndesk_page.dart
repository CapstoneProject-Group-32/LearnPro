import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/home_page.dart';

class LearnDesk extends StatelessWidget {
  const LearnDesk({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

//start focusing on studies button

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
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

//Learn Desk Container Row Method calling

              _learndeskContainerRowMethod(
                const AssetImage('assets/clock.png'),
                'Focus Timer',
                const AssetImage('assets/cloud.png'),
                'Upload Notes',
              ),
              _learndeskContainerRowMethod(
                const AssetImage('assets/flashcards.png'),
                'Create Flashcards',
                const AssetImage('assets/help.png'),
                'Request Tution',
              ),
              _learndeskContainerRowMethod(
                const AssetImage('assets/target.png'),
                'Set Goals',
                const AssetImage('assets/quize.png'),
                'Quizes',
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
    ImageProvider<Object> containerImage1,
    String containerTopic1,
    ImageProvider<Object> containerImage2,
    String containerTopic2) {
  return Container(
    color: Colors.white,
    height: 230,
    width: 400,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
//first icon start

        Container(
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

//first icon stopped and second icon started

        Container(
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
      ],
    ),
  );
}
