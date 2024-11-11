import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/pages/finder_page.dart';
import 'package:music_app/pages/home_page.dart';
import 'package:music_app/pages/settings_page.dart';
import 'package:music_app/pages/songs_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const SongsPage(),
    const HomePage(),
    const FinderPage(),
    const SettingsPage(),
  ];

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDarkColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundDarkColor,
        selectedItemColor: sliderColor,
        unselectedItemColor: Colors.white54,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Player",
            icon: Icon(FontAwesomeIcons.music),
          ),
          BottomNavigationBarItem(
            label: "Locals",
            icon: Icon(FontAwesomeIcons.database),
          ),
          BottomNavigationBarItem(
            label: "Shazam",
            icon: Icon(FontAwesomeIcons.magnifyingGlass),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(FontAwesomeIcons.gear),
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
