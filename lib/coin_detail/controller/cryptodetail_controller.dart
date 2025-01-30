import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/coinModel.dart';


class CoinDetailController extends GetxController {
  var isLoading = true.obs;
  var cryptoCoin = Rxn<CryptoCoin>();

  @override
  void onInit() {
    super.onInit();
    String symbol = Get.arguments;
    print(symbol);
    fetchCoinData(symbol);
  }

  Future<void> fetchCoinData(String symbol) async {

      isLoading(true);
      var response = await http.get(Uri.parse('https://express.pingi.co/api/v1/cryptos/$symbol'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        cryptoCoin.value = CryptoCoin.fromJson(data);
        isLoading(false);
      } else {
        Get.snackbar("Error", "Failed to load data", backgroundColor: Colors.red, colorText: Colors.white);
      }
    // } catch (e) {
    //   print(e.toString());
    //   Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    // } finally {
    //   isLoading(false);
    // }
  }
}
