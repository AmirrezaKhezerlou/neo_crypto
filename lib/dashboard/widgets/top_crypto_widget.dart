import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    return Center(
      child: SizedBox(
        height: 150,
        width: 800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final crypto = widget.cryptoList[index];
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.5, 0),
                end: Offset.zero,
              ).animate(_animations[index]),
              child: FadeTransition(
                opacity: _animations[index],
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple  ,
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
                      // Symbol and Name
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
                      // Price
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
            );
          }),
        ),
      ),
    );
  }
}