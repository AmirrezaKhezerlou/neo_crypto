import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textSize = screenSize.width > 600 ? 16.0 : 14.0;
    final isMobile = screenSize.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: textSize),
            children: [
              const TextSpan(text: 'Made with ❤ by '),
              TextSpan(
                text: 'Amirreza',
                style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://github.com/AmirrezaKhezerlou'));
                  },
              ),
              const TextSpan(text: ' with '),
              TextSpan(
                text: 'Babak\'s API',
                style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://github.com/babakcode'));
                  },
              ),
              const TextSpan(text: ', logo designed by '),
              TextSpan(
                text: 'Alef_His',
                style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://t.me/Alef_His'));
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
