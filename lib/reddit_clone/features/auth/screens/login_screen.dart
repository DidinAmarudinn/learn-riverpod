import 'package:flutter/material.dart';
import 'package:journal_riverpod/reddit_clone/theme/theme.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          icLogo,
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: kPading,
          ),
          const Text(
            "Dive into anything",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(
            height: kPading,
          ),
          Image.asset(
            imgReddit,
            height: 300,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(kPading),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                icGoogle,
                width: 34,
              ),
              label: const Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.greyColor,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    25,
                  ))),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
