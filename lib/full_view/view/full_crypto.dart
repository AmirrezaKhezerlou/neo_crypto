import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/cryptoModel.dart';

class FullCryptoPage extends StatefulWidget {
  final List<CryptoModel> cryptoList;

  const FullCryptoPage({Key? key, required this.cryptoList}) : super(key: key);

  @override
  State<FullCryptoPage> createState() => _FullCryptoPageState();
}

class _FullCryptoPageState extends State<FullCryptoPage> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _controllers = List.generate(
      widget.cryptoList.length,
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
    _scrollController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3935FF),
      appBar: AppBar(
        backgroundColor: const Color(0xff3935FF),
        elevation: 0,
        title: const Text(
          'All Cryptocurrencies',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // تعیین تعداد ستون‌ها بر اساس عرض صفحه
              int crossAxisCount;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 2;
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 3;
              } else {
                crossAxisCount = 4;
              }

              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                interactive: true,
                thickness: 8.0,
                radius: const Radius.circular(4.0),
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    // تنظیم نسبت ارتفاع به عرض برای موبایل
                    childAspectRatio: constraints.maxWidth < 600 ? 0.85 : 1,
                  ),
                  itemCount: widget.cryptoList.length,
                  itemBuilder: (context, index) {
                    final crypto = widget.cryptoList[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1.5),
                        end: Offset.zero,
                      ).animate(_animations[index]),
                      child: FadeTransition(
                        opacity: _animations[index],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
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
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                crypto.name,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                crypto.priceStr,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}