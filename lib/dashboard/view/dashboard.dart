import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:neo_crypto/dashboard/controller/dashboard_controller.dart';
import 'package:neo_crypto/dashboard/widgets/animated_timer_widget.dart';
import 'package:neo_crypto/dashboard/widgets/top_crypto_widget.dart';
import 'package:neo_crypto/full_view/view/full_crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import '../widgets/bottom_widget.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardController controller = Get.put(DashboardController());
  Duration countdownDuration = const Duration(seconds: 10);
  bool _isMenuOpen = false;

  void resetCountdown() {
    setState(() {
      countdownDuration = const Duration(seconds: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    final padding = screenSize.width > 600 ? 20.0 : 12.0;
    final titleSize = screenSize.width > 600 ? 35.0 : 28.0;
    final subTitleSize = screenSize.width > 600 ? 25.0 : 20.0;
    final cryptoCardHeight = screenSize.height * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xff3935FF),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isMenuOpen) {
                setState(() {
                  _isMenuOpen = false;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isMenuOpen ? Icons.close : Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isMenuOpen = !_isMenuOpen;
                                  });
                                },
                              ),
                              if (screenSize.width > 400) ...[
                                const SizedBox(width: 15),
                                Column(
                                  children: [
                                    const Text(
                                      'Next update in:',
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.white),
                                    ),
                                    AnimatedCountdownTimer(
                                      duration: const Duration(
                                          minutes: 1, seconds: 30),
                                      controller: controller,
                                      widgetSize: 0.3,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isDesktop)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await WindowManager.instance.minimize();
                                },
                                icon: const Icon(
                                  Icons.minimize,
                                  color: Colors.white,
                                  size: 20,
                                  semanticLabel: 'Minimize',
                                ),
                              ),
                              const SizedBox(width: 15),
                              IconButton(
                                onPressed: () {
                                  controller.showExitDialog(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                  semanticLabel: 'Exit',
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Neo Crypto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              letterSpacing: 5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Top Currencies:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: subTitleSize,
                            ),
                          ),
                          SizedBox(
                            height: cryptoCardHeight,
                            child: Obx(
                                  () => !controller.isConnecting.value
                                  ? CryptoCardsRow(
                                  cryptoList: controller.cryptoList)
                                  : Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                  )
                                      .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                      .rotate(
                                      duration:
                                      const Duration(seconds: 1),
                                      delay: const Duration(
                                          milliseconds: 500)),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(
                                  () => FullCryptoPage(
                                  cryptoList: controller.cryptoList),
                              transition: Transition.rightToLeft,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tap here to see all cryptocurrencies',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    screenSize.width > 600 ? 22.0 : 16.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                          const BottomSection()
                              .animate(
                              onPlay: (controller) => controller.repeat())
                              .shimmer(
                              duration: const Duration(seconds: 1),
                              delay: const Duration(milliseconds: 500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: _isMenuOpen ? 0 : -(screenSize.width * 0.6),
            top: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              width: screenSize.width * 0.6,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('More options'),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(padding),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.data.length,
                      itemBuilder: (context, index) {
                        String key = controller.data.keys.elementAt(index);
                        String value = controller.data[key]!;
                        return AnimatedOpacity(
                          opacity: _isMenuOpen ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                launchUrl(Uri.parse(
                                    'https://github.com/babakcode/currency.prices.free'));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xff3935FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    value,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    key,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate(
                            onPlay: (controller) => controller.repeat())
                            .shimmer(
                            duration: const Duration(seconds: 1),
                            delay: const Duration(milliseconds: 500));
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}