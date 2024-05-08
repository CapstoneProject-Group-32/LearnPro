import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_page.dart';

class StudyBuddies extends StatelessWidget {
  const StudyBuddies({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

//Find Your Study Buddies button

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
                        "Student Community",
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

//Search Bar

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),

//Buttons

              Container(
                color: Colors.white,
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xFF74FE8A),
                        ),
                        child: const Center(child: Text("People")),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: const Center(child: Text("Groups")),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xFFD9D9D9),
                        ),
                        child: const Center(child: Text("Tutored You")),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

//study buddie tution card method calling

              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),

              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),
              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),

              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),
              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),

              _studybuddyCard(
                const AssetImage('assets/profilepic.png'),
                'Chamod Ganegoda',
                'SE Junior',
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//study buddie tution card method

Widget _studybuddyCard(
    ImageProvider<Object> userImage, String userName, String userLevel) {
  return Container(
    width: 370,
    height: 100,
    decoration: ShapeDecoration(
      color: const Color(0xEAF6EEEE),
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(5),
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: userImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              userLevel,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 132,
              height: 21,
              decoration: ShapeDecoration(
                color: const Color(0xFF74FE8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
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
                  'request tution',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 70,
              height: 20,
              decoration: ShapeDecoration(
                color: const Color(0xFFFCFCFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
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
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15.55,
            ),
          ],
        ),
      ],
    ),
  );
}
