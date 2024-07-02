import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:LearnPro/tutoring_system/learning_records.dart';
import 'package:flutter/material.dart';

class LearningInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Learning records',
      ),
      body: LearningRecords(),
    );
  }
}
