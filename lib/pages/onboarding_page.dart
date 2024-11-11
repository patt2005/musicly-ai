import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/consts.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/pages/main_page.dart';

// ignore: must_be_immutable
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  int _pageIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildOnboardingPage({
    required String title,
    required String imagePath,
    required String description,
    required BuildContext context,
  }) {
    return Container(
      color: backgroundDarkColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.15),
            Image.asset(
              imagePath,
              width: 175,
              height: 175,
            ),
            SizedBox(height: screenSize.height * 0.05),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.025),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    width: 15,
                    height: 15,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: _pageIndex == i ? sliderColor : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PlayButtonController());

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: sliderColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: const Icon(
            FontAwesomeIcons.arrowRightLong,
            color: Colors.white,
          ),
          onPressed: () async {
            if (_pageIndex == 2) {
              await Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            } else {
              _pageIndex++;
              setState(() {});
              await _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
      backgroundColor: backgroundDarkColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          _buildOnboardingPage(
            title: "Welcome to MusiclyAI!",
            description:
                "Enjoy your favorite tracks directly from your device. Our seamless player supports all your local files for an uninterrupted listening experience.",
            context: context,
            imagePath: "images/player.png",
          ),
          _buildOnboardingPage(
            title: "Powerful Music Search",
            imagePath: "images/music.png",
            description:
                "Type in the title or artist, and instantly get a comprehensive list of songs to explore. Discover new favorites, uncover hidden gems, and reminisce with old classics in just a few seconds.",
            context: context,
          ),
          _buildOnboardingPage(
            title: "Find Songs by Audio",
            imagePath: "images/note.png",
            description:
                "Heard a song but don’t know the title? Simply provide an audio file or a part of the song, and our AI-powered search will find the song for you. Never miss a beat!",
            context: context,
          ),
        ],
      ),
    );
  }
}
