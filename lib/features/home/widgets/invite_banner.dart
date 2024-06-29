import 'package:flutter/material.dart';

class InviteBanner extends StatelessWidget {
  const InviteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/invite.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(
          children: [
            Positioned(
              right: 72,
              top: 83,
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
