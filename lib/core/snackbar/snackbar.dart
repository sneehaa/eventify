import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar({
  required String message,
  required BuildContext context,
  required bool isSuccess,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: constraints
                    .maxWidth, // Set the width to the maximum available width
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color.fromARGB(255, 193, 243, 206)
                      : const Color.fromARGB(255, 248, 127, 127),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSuccess ? "Success!" : "Oops!",
                            style: GoogleFonts.libreBaskerville(
                                fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            message,
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: null, // Remove the maxLines constraint
                            overflow: TextOverflow.visible, // Change to visible
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: SvgPicture.asset(
                    isSuccess
                        ? "assets/icons/check.svg"
                        : "assets/icons/bubbles.svg",
                    height: 40,
                    width: 40,
                    theme: SvgTheme(
                        currentColor: isSuccess
                            ? const Color.fromARGB(255, 193, 243, 206)
                            : const Color.fromARGB(255, 248, 127, 127)),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            ],
          );
        },
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
