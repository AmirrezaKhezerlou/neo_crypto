import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:neo_crypto/utils/toastification_class.dart';
import '../../model/cryptoModel.dart';

class DashboardController extends GetxController {
  RxBool isConnecting = false.obs;
  String apiKey = '610WQoU2w1jU95BkfiAP81e4u6kEDFLA5';
  final String url = 'https://currency.babakcode.com/api/v2/crypto/all/USD';
  RxList<CryptoModel> cryptoList = <CryptoModel>[].obs;
  Map<String, String> data = {
    'Gituhb': 'assets/github.svg',
    'Reminder': 'assets/reminder.svg',
  };

  @override
  void onInit() {
    getCurrencyData(apiKey);
    super.onInit();
  }

  Future<void> getCurrencyData(String apiKey) async {
    MessagingClass mc = MessagingClass();
    cryptoList.clear();
    isConnecting.value = true;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'api-key': apiKey,
        },
      );
      isConnecting.value = false;
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<CryptoModel> cryptos =
            data.map((currency) => CryptoModel.fromJson(currency)).toList();
        cryptoList.value = cryptos;
      } else {
        mc.showMessage(response.statusCode.toString() + response.body, true);
      }
    } catch (e) {
      mc.showMessage('Network Error', true);
    }
  }


  Future<void> showExitDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8 * curve.value,
            sigmaY: 8 * curve.value,
          ),
          child: FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(curve),
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Exit Application',
                  style: TextStyle(
                    color: const Color(0xff3935FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      size: 64,
                      color: const Color(0xff3935FF),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Are you sure you want to exit?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xff3935FF),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () => exit(0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3935FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
