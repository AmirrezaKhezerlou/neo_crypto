import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../model/coinModel.dart';
import '../controller/cryptodetail_controller.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CoinDetailController controller = Get.put(CoinDetailController());

    return Scaffold(
      backgroundColor: const Color(0xff3935FF),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return _buildLoading();
        // }
        //
        // if (controller.cryptoCoin.value == null) {
        //   return _buildNoData();
        // }

        CryptoCoin? coin = controller.cryptoCoin.value;
        return _buildContent(coin,controller);
      }),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.fill,
        ).animate(onPlay: (controller) => controller.repeat()).rotate(
          duration: const Duration(seconds: 1),
          delay: const Duration(milliseconds: 500),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Text(
        "No Data Available",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildContent(dynamic coin,CoinDetailController controller) {
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.png'),
            fit: isDesktop ? BoxFit.fill : BoxFit.cover, // بهینه‌شده برای موبایل
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 800,
            height: Get.height,
            child: Column(
              children: [
                _buildHeader(coin,controller),
                const SizedBox(height: 24),
                _buildMainStats(coin,controller),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildDetailedStats(coin),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic coin,CoinDetailController controller) {

    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coin?.name ?? 'Loading...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                coin?.symbol?.toUpperCase() ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      )
    ).animate().scale(duration: 400.ms);
  }

  Widget _buildMainStats(dynamic coin,CoinDetailController controller) {
    final String tag = Get.arguments.isNotEmpty ? Get.arguments : 'default-tag';
    
    String formatNumber(double number) {

      int intValue = number > 100 ? number.toInt() : number.round();
      String formatted = intValue.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
              (match) => '${match[1]},'
      );

      return formatted;
    }
    return Hero(
      tag: tag,
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child:!controller.isLoading.value? Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMainStatItem(
              Icons.attach_money,
              "Current Price",
                "\$${formatNumber(coin?.currentPrice ?? 0)}"

            ),
            _buildVerticalDivider(),
            _buildMainStatItem(
              Icons.trending_up,
              "24h Change",
              "${coin?.priceChangePercentage1w?.toStringAsFixed(2) ?? '0.00'}%",
              isChange: true,
              change: coin?.priceChangePercentage1w ?? 0.0,
            ),
            _buildVerticalDivider(),
            _buildMainStatItem(
              Icons.bar_chart,
              "Market Cap",
              "\$${coin?.marketCap?.toStringAsFixed(2) ?? '0.00'}",
            ),
          ],
        ):Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fill,

                ),
              ),
              const Text('Fetching More info ...',style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildMainStatItem(IconData icon, String title, String value,
      {bool isChange = false, double? change}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isChange
              ? (change != null && change >= 0 ? Colors.green : Colors.red)
              : Colors.black54,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isChange
                ? (change != null && change >= 0 ? Colors.green : Colors.red)
                : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(dynamic coin) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceAround,
     children: [
       _buildDetailCard(
         "24h Trading Volume",
         "\$${coin?.volume24h?.toStringAsFixed(2) ?? '0.00'}",
         Icons.show_chart,
       ),
       
       _buildDetailCard(
         "24h High/Low",
         "\$${coin?.high24h?.toStringAsFixed(2) ?? '0.00'}\n\$${coin?.low24h?.toStringAsFixed(2) ?? '0.00'}",
         Icons.timeline,
         isHighLow: true,
       ),
     ],
   );
  }

  Widget _buildDetailCard(String title, String value, IconData icon,
      {bool isHighLow = false}) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: Get.width/3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          isHighLow
              ? Column(
            children: value.split('\n').map((text) => Text(text)).toList(),
          )
              : Text(value),
        ],
      ),
    );
  }
}
