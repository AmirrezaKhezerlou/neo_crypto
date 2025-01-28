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
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isMenuOpen ? Icons.close : Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isMenuOpen =
                                    !_isMenuOpen; // Toggle menu open/close
                              });
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Next update in:',
                                style:
                                    TextStyle(fontSize: 8, color: Colors.white),
                              ),
                              AnimatedCountdownTimer(
                                duration:
                                    const Duration(minutes: 1, seconds: 30),
                                controller: controller,
                                widgetSize: 0.3,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await WindowManager.instance.minimize();
                            },
                            icon: Center(
                              child: const Icon(
                                semanticLabel: 'Minimize',
                                Icons.minimize,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            onPressed: () {
                              controller.showExitDialog(context);
                            },
                            icon: const Center(
                              child: Icon(
                                semanticLabel: 'Exit',
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Neo Crypto',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Top Currencies:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: Obx(
                      () => !controller.isConnecting.value
                          ? CryptoCardsRow(cryptoList: controller.cryptoList)
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
                                        duration: const Duration(seconds: 1),
                                        delay:
                                            const Duration(milliseconds: 500)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.to(
                      () => FullCryptoPage(cryptoList: controller.cryptoList),
                      transition: Transition.rightToLeft,
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tap here to see all cryptocurrencies',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  const BottomSection()
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          duration: const Duration(seconds: 1),
                          delay: const Duration(milliseconds: 500)),
                ],
              ),
            ),
          ),
          // Menu Slide Animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: _isMenuOpen ? 0 : -210,
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
              width: 210,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('More options')],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate(
                                onPlay: (controller) => controller.repeat())
                            .shimmer(
                                duration: const Duration(seconds: 1),
                                delay: const Duration(milliseconds: 500));
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Version  1.0.0',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
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
