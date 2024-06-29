import 'package:eventify/config/router/app_router.dart';
import 'package:flutter/material.dart';

void showCustomModalSheet({
  required BuildContext context,
  required String message,
  required VoidCallback onYesPressed,
  Widget? image,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        height: 554,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Container(
              width: 52,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 15),
            if (image != null) image,
            if (image != null) const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6C2C2),
                    fixedSize: const Size(141, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onYesPressed();
                    Navigator.pushNamed(context, AppRoute.loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5449),
                    fixedSize: const Size(141, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
