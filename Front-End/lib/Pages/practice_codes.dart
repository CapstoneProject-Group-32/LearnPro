import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //Search bar

        children: [
          Container(
            width: 342,
            height: 35,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 343,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD0D0D0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 9,
                  top: 5,
                  child: Container(
                    width: 89,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(children: []),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search...',
                          style: TextStyle(
                            color: Color(0xFF525252),
                            fontSize: 14,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400,
                            height: 0.09,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 269,
                  top: 5,
                  child: Container(
                    width: 67,
                    height: 26,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 67,
                            height: 26,
                            decoration: ShapeDecoration(
                              color: Color(0xFF73FD89),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFF5279F4)),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 7,
                          top: 4,
                          child: Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 43,
                          top: 3,
                          child: Container(
                            width: 21,
                            height: 21,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 21,
                                    height: 21,
                                    decoration: ShapeDecoration(
                                      color: Color(0x006BA288),
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 4.38,
                                  top: 4.38,
                                  child: Container(
                                    width: 12.25,
                                    height: 12.25,
                                    padding: const EdgeInsets.only(
                                      top: 1.42,
                                      left: 1.42,
                                      right: 0.44,
                                      bottom: 0.44,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Today goals

                Container(
                  width: 325,
                  height: 355,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 1,
                        top: 0,
                        child: Text(
                          'Today goals',
                          style: TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 22,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w600,
                            height: 0.06,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 55,
                        child: Container(
                          width: 323,
                          height: 63,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 46,
                                top: 8,
                                child: Container(
                                  width: 277,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 287,
                                top: 23,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFF4F4F4),
                                    shape:
                                        OvalBorder(side: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 254,
                                top: 20,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: const Stack(children: []),
                                ),
                              ),
                              Positioned(
                                left: 59,
                                top: 0,
                                child: Container(
                                  width: 55,
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF2BFF33),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Studying',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF262626),
                                          fontSize: 8,
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 0.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 291,
                                top: 30,
                                child: Container(
                                  width: 13,
                                  height: 8,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 3,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(0.90),
                                          child: Container(
                                            width: 6.40,
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 4,
                                        top: 8,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(-0.73),
                                          child: Container(
                                            width: 12.04,
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 65,
                                top: 25,
                                child: SizedBox(
                                  width: 94,
                                  child: Text(
                                    'Learning dart',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 12,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                top: 28,
                                child: Text(
                                  '9:30',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF262626),
                                    fontSize: 12,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 132,
                        child: Container(
                          width: 325,
                          height: 63,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 48,
                                top: 8,
                                child: Container(
                                  width: 277,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 289,
                                top: 23,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFF4F4F4),
                                    shape:
                                        OvalBorder(side: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 256,
                                top: 20,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: const Stack(children: []),
                                ),
                              ),
                              Positioned(
                                left: 61,
                                top: 0,
                                child: Container(
                                  width: 53,
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF2BFF33),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Revision',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 0.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 293,
                                top: 30,
                                child: Container(
                                  width: 13,
                                  height: 8,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 3,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(0.90),
                                          child: Container(
                                            width: 6.40,
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 4,
                                        top: 8,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(-0.73),
                                          child: Container(
                                            width: 12.04,
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 65,
                                top: 26,
                                child: SizedBox(
                                  width: 151,
                                  child: Text(
                                    'Solving problems in dart',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 12,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                top: 30,
                                child: Text(
                                  '12:30',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF262626),
                                    fontSize: 12,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 212,
                        child: Container(
                          width: 323,
                          height: 63,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 46,
                                top: 8,
                                child: Container(
                                  width: 277,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 287,
                                top: 23,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFF4F4F4),
                                    shape:
                                        OvalBorder(side: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 256,
                                top: 23,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: const Stack(children: []),
                                ),
                              ),
                              Positioned(
                                left: 59,
                                top: 0,
                                child: Container(
                                  width: 55,
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF2BFF33),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Studying',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF262626),
                                          fontSize: 8,
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 0.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 58,
                                top: 27,
                                child: SizedBox(
                                  width: 190,
                                  child: Text(
                                    'Learning software architecture',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 12,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                top: 29,
                                child: Text(
                                  '2:30',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF262626),
                                    fontSize: 12,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 292,
                        child: Container(
                          width: 325,
                          height: 63,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 48,
                                top: 8,
                                child: Container(
                                  width: 277,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 289,
                                top: 23,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFF4F4F4),
                                    shape:
                                        OvalBorder(side: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 256,
                                top: 20,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: const Stack(children: []),
                                ),
                              ),
                              Positioned(
                                left: 61,
                                top: 0,
                                child: Container(
                                  width: 48,
                                  height: 16,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF2AD731),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Project',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF050306),
                                          fontSize: 8,
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 0.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 64,
                                top: 26,
                                child: SizedBox(
                                  width: 122.61,
                                  child: Text(
                                    'Designing front end',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 12,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                top: 30,
                                child: Text(
                                  '4:30',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF262626),
                                    fontSize: 12,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Join Groups

                Container(
                  width: 209.40,
                  height: 240,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 209.40,
                          height: 146.99,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/209x147"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 146.99,
                        child: Container(
                          width: 209.40,
                          height: 93.01,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF4F4F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 43,
                        top: 197.51,
                        child: Container(
                          width: 127,
                          height: 27.56,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 127,
                                  height: 27.56,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF7BE7FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 45.72,
                                top: 4.59,
                                child: SizedBox(
                                  width: 52.07,
                                  height: 17.22,
                                  child: Text(
                                    'View',
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 14,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w600,
                                      height: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 43,
                        top: 167,
                        child: SizedBox(
                          width: 139,
                          height: 11,
                          child: Text(
                            'Java programmers',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w500,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //view all button

                Container(
                  width: 275,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 275,
                          height: 39,
                          decoration: ShapeDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 97,
                        top: 3,
                        child: SizedBox(
                          width: 77,
                          height: 27,
                          child: Text(
                            'view all',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Your freinds

                Container(
                  width: 209,
                  height: 240,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 209,
                          height: 240,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF4F4F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 41,
                        top: 194,
                        child: Container(
                          width: 127,
                          height: 27.56,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 127,
                                  height: 27.56,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF7BE7FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 14,
                                top: 4.50,
                                child: SizedBox(
                                  width: 109,
                                  height: 17,
                                  child: Text(
                                    'Request Tution',
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 14,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w600,
                                      height: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 55,
                        top: 11,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/100x100"),
                              fit: BoxFit.fill,
                            ),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 78,
                        top: 129,
                        child: SizedBox(
                          width: 60,
                          height: 15,
                          child: Text(
                            'David',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w600,
                              height: 0.04,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 33,
                        top: 155,
                        child: SizedBox(
                          width: 153,
                          height: 16,
                          child: Text(
                            'CS undergraduate',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w300,
                              height: 0.04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //plugin button

                Container(
                  width: 275,
                  height: 39,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 275,
                          height: 39,
                          decoration: ShapeDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 97,
                        top: 3,
                        child: SizedBox(
                          width: 77,
                          height: 27,
                          child: Text(
                            'view all',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //floating button

                Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: ShapeDecoration(
                            color: Color(0xFF74FE8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        top: 18,
                        child: Container(
                          width: 24,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(children: []),
                        ),
                      ),
                    ],
                  ),
                ),

                //study buddy widget

                Container(
                  width: 342,
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 342,
                          height: 100,
                          decoration: ShapeDecoration(
                            color: Color(0xEAF6EEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 0,
                        child: Container(
                          width: 97,
                          height: 97,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/97x97"),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(180),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 120,
                        top: 19,
                        child: SizedBox(
                          width: 90,
                          height: 19,
                          child: Text(
                            'David Laid',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 121,
                        top: 41,
                        child: SizedBox(
                          width: 69,
                          height: 18,
                          child: Text(
                            'CS Major',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w200,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 120,
                        top: 67,
                        child: Container(
                          width: 132,
                          height: 21,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 132,
                                  height: 21,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF74FE8A),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 9,
                                top: 6,
                                child: SizedBox(
                                  width: 113,
                                  height: 7,
                                  child: Text(
                                    'request tution',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 265,
                        top: 67,
                        child: Container(
                          width: 71,
                          height: 21,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 71,
                                  height: 21,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFCFCFC),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                top: 7,
                                child: SizedBox(
                                  width: 39,
                                  height: 8,
                                  child: Text(
                                    'add',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0.07,
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
                ),

                //quize page

                Container(
                  width: 342,
                  height: 545,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 342,
                          height: 545,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF2F2F2),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 29,
                        top: 79,
                        child: SizedBox(
                          width: 281,
                          height: 158,
                          child: Text(
                            '\nWhich subatomic particle is responsible for the mass of an atom?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w300,
                              height: 0.05,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 27,
                        top: 79,
                        child: Text(
                          'Atomic Structure',
                          style: TextStyle(
                            color: Color(0xFFD60000),
                            fontSize: 24,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w500,
                            height: 0.05,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 293,
                        top: 11,
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF09EA70),
                                    shape:
                                        OvalBorder(side: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 11,
                                top: 8,
                                child: SizedBox(
                                  width: 18,
                                  height: 24,
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 143,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: Color(0xFF142BF7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 6,
                        top: 6,
                        child: SizedBox(
                          width: 126,
                          height: 34,
                          child: Text(
                            'Chemistry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 263,
                        child: Container(
                          width: 246,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 246,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 25,
                                top: 10,
                                child: SizedBox(
                                  width: 139,
                                  height: 22,
                                  child: Text(
                                    'A) Protons',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 321,
                        child: Container(
                          width: 246,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 246,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 25,
                                top: 9,
                                child: SizedBox(
                                  width: 161,
                                  height: 22,
                                  child: Text(
                                    'B) Electrons',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 386,
                        child: Container(
                          width: 246,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 246,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 24,
                                top: 12,
                                child: SizedBox(
                                  width: 158,
                                  height: 22,
                                  child: Text(
                                    'C) Neutrons',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 457,
                        child: Container(
                          width: 246,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 246,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 28,
                                top: 12,
                                child: SizedBox(
                                  width: 158,
                                  height: 22,
                                  child: Text(
                                    'D) Nucleons',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 0.05,
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
                ),

                //statistic bar

                Container(
                  width: 341,
                  height: 69,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 341,
                          height: 69,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFCFCFC),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 36,
                        top: 21,
                        child: SizedBox(
                          width: 71,
                          height: 22,
                          child: Text(
                            'Points',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 261,
                        top: 21,
                        child: SizedBox(
                          width: 59,
                          height: 28,
                          child: Text(
                            '2005',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //navigation bar plugin

                Container(
                  width: 390,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 390,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        top: 11,
                        child: Container(
                          width: 31,
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.11, vertical: 3.21),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 28.79,
                                height: 23.57,
                                child: Stack(children: []),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 100,
                        top: 12,
                        child: Container(
                          width: 30,
                          height: 27,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.07, vertical: 0.96),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 27.86,
                                height: 25.07,
                                child: Stack(children: []),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 181,
                        top: 12,
                        child: Container(
                          width: 28,
                          height: 28,
                          padding: const EdgeInsets.all(1),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: double.infinity,
                                  child: Stack(children: []),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 334,
                        top: 8,
                        child: Container(
                          width: 32,
                          height: 28,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.14, vertical: 1),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 29.71,
                                height: 26,
                                child: Stack(children: []),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 265,
                        top: 10,
                        child: Container(
                          width: 30,
                          height: 24,
                          padding: const EdgeInsets.only(
                            top: 2.57,
                            left: 1.07,
                            right: 1.07,
                            bottom: 0.86,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 27.86,
                                height: 20.57,
                                child: Stack(children: []),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
