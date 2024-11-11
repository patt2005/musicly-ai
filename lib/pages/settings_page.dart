import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDarkColor,
      appBar: AppBar(
        backgroundColor: backgroundDarkColor,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 21,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const SettingsSectionTitle(title: "General"),
            SettingsTile(
              title: "Privacy Policy",
              icon: Icons.privacy_tip_outlined,
              onTap: () async {
                const url =
                    'https://docs.google.com/document/d/1uth_ytIH6sL8eJu1w2loQkPMonuRYz-c1yq5xkVK71k/edit?usp=sharing';
                await _launchUrl(context, url);
              },
            ),
            SettingsTile(
              title: "Terms of Use",
              icon: Icons.article_outlined,
              onTap: () async {
                const url =
                    'https://docs.google.com/document/d/1VbemNFyZpawCaigbmEPzndAt3HN-iH4VsMH0Znsi-gU/edit?usp=sharing';
                await _launchUrl(context, url);
              },
            ),
            SettingsTile(
              title: "Contact Us",
              icon: Icons.mail_outline,
              onTap: () {
                _showContactDialog(context);
              },
            ),
            const Divider(
              color: Colors.white24,
              thickness: 0.5,
            ),
            const SettingsSectionTitle(title: "Support"),
            SettingsTile(
              title: "FAQ",
              icon: Icons.help_outline,
              onTap: () async {
                const url =
                    'https://docs.google.com/document/d/1VbemNFyZpawCaigbmEPzndAt3HN-iH4VsMH0Znsi-gU/edit?usp=sharing';
                await _launchUrl(context, url);
              },
            ),
            SettingsTile(
              title: "Feedback",
              icon: Icons.feedback_outlined,
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            const Divider(
              color: Colors.white24,
              thickness: 0.5,
            ),
            const SettingsSectionTitle(title: "About"),
            SettingsTile(
              title: "App Version",
              icon: Icons.info_outline,
              onTap: () {
                _showAppVersionDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint("There was an error loading this website");
    }
  }

  void _showContactDialog(BuildContext context) async {
    const email = "leahreyestr@gmx.com";
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeQueryComponent('subject=Support Inquiry'),
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: const Text("No email client found on this device."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Feedback"),
        content: const Text(
          "We value your feedback. Please send us your feedback at leahreyestr@gmx.com.",
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showAppVersionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("App Version"),
        content: const Text("Version: 1.0.0"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.white70,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white70,
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
