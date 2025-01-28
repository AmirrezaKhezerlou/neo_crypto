class Currency {
  final String priceStr;
  final double price;
  final String currency;
  final String name;
  final String svg;
  final int timestamp;

  Currency({
    required this.priceStr,
    required this.price,
    required this.currency,
    required this.name,
    required this.svg,
    required this.timestamp,
  });

  // تابع برای تبدیل داده‌های JSON به مدل Currency
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      priceStr: json['priceStr'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      name: json['name'],
      svg: json['svg'],
      timestamp: json['timestamp'],
    );
  }

  // تابع برای تبدیل مدل Currency به فرمت JSON
  Map<String, dynamic> toJson() {
    return {
      'priceStr': priceStr,
      'price': price,
      'currency': currency,
      'name': name,
      'svg': svg,
      'timestamp': timestamp,
    };
  }
}
