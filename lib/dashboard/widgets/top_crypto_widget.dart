import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // برای استفاده از Platform
import 'package:get/get.dart';
import 'package:neo_crypto/coin_detail/view/coin_detail.dart';
import '../../model/cryptoModel.dart';

class CryptoCardsRow extends StatefulWidget {
  final List<CryptoModel> cryptoList;

  const CryptoCardsRow({Key? key, required this.cryptoList}) : super(key: key);

  @override
  State<CryptoCardsRow> createState() => _CryptoCardsRowState();
}

class _CryptoCardsRowState extends State<CryptoCardsRow> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      );
    }).toList();

    Future.delayed(const Duration(milliseconds: 100), () {
      for (var i = 0; i < _controllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 150), () {
          _controllers[i].forward();
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // تعیین تعداد کارت‌ها بر اساس عرض صفحه
        int numberOfCards = 4; // فقط ۴ ارز برتر را نشان می‌دهیم

        // برای ویندوز از Row و برای اندروید از GridView استفاده می‌کنیم
        if (defaultTargetPlatform == TargetPlatform.android) {
          // فقط ۴ ارز برتر را به صورت گرید ویو در اندروید نمایش می‌دهیم
          return GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.cryptoList.length < 4 ? widget.cryptoList.length : 4, // حداکثر ۴ ارز
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // دو ستون در هر ردیف
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: (constraints.maxWidth / 2) / 180, // سایز کارت‌ها ریسپانسیو
            ),
            itemBuilder: (context, index) {
              final crypto = widget.cryptoList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: crypto.logo,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) =>
                            const Icon(Icons.currency_bitcoin),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        crypto.symbol,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        crypto.name,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        crypto.priceStr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                numberOfCards.clamp(0, widget.cryptoList.length),
                    (index) {
                      // محاسبه عرض هر کارت
                      double cardWidth = (constraints.maxWidth - (20.0 * (numberOfCards - 1))) / numberOfCards;
                      // محدود کردن حداقل عرض کارت
                      cardWidth = cardWidth.clamp(120.0, 180.0);
                  final crypto = widget.cryptoList[index];
                  return GestureDetector(
                    onTap: ()=>Get.to(()=>CoinDetailPage(),arguments: crypto.symbol),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 20,
                        right: index == numberOfCards - 1 ? 16 : 0,
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero)
                            .animate(_animations[index]),
                        child: FadeTransition(
                          opacity: _animations[index],
                          child: Container(
                            width: cardWidth-10,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: crypto.logo,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, error, stackTrace) =>
                                      const Icon(Icons.currency_bitcoin),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  crypto.symbol,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  crypto.name,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  crypto.priceStr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
