class CryptoModel {
  String name;
  double price;
  String priceStr;
  String logo;
  String symbol;
  int timestamp;

  CryptoModel({
    required this.name,
    required this.price,
    required this.priceStr,
    required this.logo,
    required this.symbol,
    required this.timestamp,
  });

  // متدی برای ساخت CryptoModel از JSON
  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      name: json['name'],
      price: json['price'].toDouble(),
      priceStr: json['priceStr'],
      logo: json['logo'],
      symbol: json['symbol'],
      timestamp: json['timestamp'],
    );
  }

  // متدی برای تبدیل CryptoModel به JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'priceStr': priceStr,
      'logo': logo,
      'symbol': symbol,
      'timestamp': timestamp,
    };
  }
}
