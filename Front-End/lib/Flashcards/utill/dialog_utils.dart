

// import 'package:flutter/material.dart';

// void showLoadingDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     },
//   );
// }

// void hideLoadingDialog(BuildContext context) {
//   Navigator.of(context).pop();
// }

import 'package:flutter/material.dart';

import 'generating_gif.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: CustomLoadingAnimation(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}
