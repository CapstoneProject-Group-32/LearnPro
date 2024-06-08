// lib/screens/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
import 'package:flutter_application_1/Flashcards/widgets/flashcard_widget.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:provider/provider.dart';

import 'content_form.dart';
import 'create_flashcard_screen.dart';
import 'flashcard_library_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<GenerateFlashcard>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Profile back button
            InkWell(
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
                    width: 8,
                  ),
                  Text(
                    "Flash Cards",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Notification button
            IconButton(
              icon: const Icon(
                Icons.library_books,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            FlashcardLibraryScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContentForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
