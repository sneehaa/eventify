import 'package:flutter/material.dart';

class InviteBanner extends StatelessWidget {
  const InviteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: 391,
        height: 134,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/invite.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 80,
              top: 85,
              width: 100,
              height: 30,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, 
                  backgroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
                ),
                child: const Text('Invite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
