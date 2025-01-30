import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/cryptodetail_controller.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CoinDetailController controller = Get.put(CoinDetailController());

    return Scaffold(
      backgroundColor: const Color(0xff3935FF),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.png'),
            fit: MediaQuery.of(context).size.width > 800 ? BoxFit.fill : BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 800,
              height: MediaQuery.of(context).size.height,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (controller.cryptoCoin.value == null) {
                  return const Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                final coin = controller.cryptoCoin.value!;
                return Column(
                  children: [
                    _buildHeader(coin),
                    const SizedBox(height: 24),
                    _buildMainStats(coin),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildDetailedStats(coin),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic coin) {
    return Padding(
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
                coin.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                coin.symbol.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ).animate().slideX(duration: 400.ms),
    );
  }

  Widget _buildMainStats(dynamic coin) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMainStatItem(
            Icons.attach_money,
            "Current Price",
            "\$${coin.currentPrice.toStringAsFixed(2)}",
          ),
          _buildVerticalDivider(),
          _buildMainStatItem(
            Icons.trending_up,
            "24h Change",
            "${coin.priceChangePercentage1w.toStringAsFixed(2)}%",
            isChange: true,
            change: coin.priceChangePercentage1w,
          ),
          _buildVerticalDivider(),
          _buildMainStatItem(
            Icons.bar_chart,
            "Market Cap",
            "\$${coin.marketCap.toStringAsFixed(2)}",
          ),
        ],
      ).animate().scale(duration: 400.ms),
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
              ? (change != null && change >= 0
              ? Colors.green
              : Colors.red)
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
                ? (change != null && change >= 0
                ? Colors.green
                : Colors.red)
                : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(dynamic coin) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDetailCard(
          "24h Trading Volume",
          "\$${coin.volume24h.toStringAsFixed(2)}",
          Icons.show_chart,
        ),
        _buildDetailCard(
          "24h High/Low",
          "\$${coin.high24h.toStringAsFixed(2)}\n\$${coin.low24h.toStringAsFixed(2)}",
          Icons.timeline,
          isHighLow: true,
        ),
      ].animate(interval: 100.ms).slideY(duration: 400.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon,
      {bool isHighLow = false}) {
    return Container(
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
          if (isHighLow) ...[
            Text(
              "High: ${value.split('\n')[0]}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Low: ${value.split('\n')[1]}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}