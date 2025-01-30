class CryptoCoin {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double marketCap;
  final double priceChange24h;
  final double volume24h;
  final double circulatingSupply;

  // داده‌های جدید برای نمودار
  final OHLCV ohlcv1h;
  final OHLCV ohlcv24h;
  final double priceChangePercentage1w;
  final double high24h;
  final double low24h;

  CryptoCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.marketCap,
    required this.priceChange24h,
    required this.volume24h,
    required this.circulatingSupply,

    required this.ohlcv1h,
    required this.ohlcv24h,
    required this.priceChangePercentage1w,
    required this.high24h,
    required this.low24h,
  });

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['data']['info']['_id'] as String,
      name: json['data']['info']['name'] as String,
      symbol: json['data']['info']['symbol'] as String,
      currentPrice: double.parse(json['data']['price']['current_price'].toString()),
      marketCap: double.parse(json['data']['info']['statistics']['marketcap']['current_marketcap_usd'].toString()),
      priceChange24h: double.parse(json['data']['info']['statistics']['market_data']['ohlcv_last_24_hour']['close'].toString()) -
          double.parse(json['data']['info']['statistics']['market_data']['ohlcv_last_24_hour']['open'].toString()),
      volume24h: double.parse(json['data']['info']['statistics']['market_data']['volume_last_24_hours'].toString()),
      circulatingSupply: double.parse(json['data']['info']['statistics']['supply']['circulating'].toString()),

      ohlcv1h: OHLCV.fromJson(json['data']['info']['statistics']['market_data']['ohlcv_last_1_hour']),
      ohlcv24h: OHLCV.fromJson(json['data']['info']['statistics']['market_data']['ohlcv_last_24_hour']),
      priceChangePercentage1w: double.parse(json['data']['info']['statistics']['roi_data']['percent_change_last_1_week'].toString()),
      high24h: double.parse(json['data']['price']['max_price'].toString()),
      low24h: double.parse(json['data']['price']['min_price'].toString()),
    );
  }
}


class OHLCV {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  OHLCV({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory OHLCV.fromJson(Map<String, dynamic> json) {
    return OHLCV(
      open: double.parse(json['open'].toString()),
      high: double.parse(json['high'].toString()),
      low: double.parse(json['low'].toString()),
      close: double.parse(json['close'].toString()),
      volume: double.parse(json['volume'].toString()),
    );
  }
}