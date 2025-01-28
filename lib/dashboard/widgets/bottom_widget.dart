import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 16),
              children: [
                TextSpan(text: 'Made with ❤ by '),
                TextSpan(
                  text: 'Amirreza',
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    launchUrl(Uri.parse('https://github.com/AmirrezaKhezerlou'));
                  },
                ),
                TextSpan(text: ' with '),
                TextSpan(
                  text: 'Babak\'s API',
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    launchUrl(Uri.parse('https://github.com/babakcode'));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
