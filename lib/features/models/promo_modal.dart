import 'dart:convert';

import 'package:eventify/core/storage/flutter_secure_storage.dart';
import 'package:eventify/features/models/promocode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final SecureStorage secureStorage = SecureStorage();

final Logger logger = Logger();

void showCustomModalSheet({
  required BuildContext context,
  required List<PromoCode> promoCodes,
  required Function(String) onApplyPressed,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
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
            Text(
              'Promo Code',
              style: GoogleFonts.libreBaskerville(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8CC8B0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: promoCodes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${promoCodes[index].code} ${promoCodes[index].discount}% off',
                          style: GoogleFonts.libreBaskerville(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onApplyPressed(promoCodes[index].code);
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(100, 25)),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 5),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                                const Color(0xFF8CC8B0)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            'apply',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<List<PromoCode>> fetchPromoCodesFromBackend() async {
  try {
    String? token = await secureStorage.readToken();

    final url = Uri.parse('http://192.168.68.109:5500/api/promo-codes');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['promoCodes'] != null) {
        List<dynamic> promoCodesJson = jsonData['promoCodes'];
        return promoCodesJson.map((code) => PromoCode.fromJson(code)).toList();
      } else {
        return [];
      }
    } else {
      logger
          .e('Failed to load promo codes. Status code: ${response.statusCode}');
      throw Exception(
          'Failed to load promo codes. Status code: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Error fetching promo codes: $e');
    rethrow;
  }
}
