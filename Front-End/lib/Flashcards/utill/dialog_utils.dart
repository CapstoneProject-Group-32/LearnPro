import 'package:flutter/material.dart';

import 'generating_gif.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CustomLoadingAnimation(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}
