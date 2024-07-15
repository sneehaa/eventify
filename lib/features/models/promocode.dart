class PromoCode {
  final String id;
  final String code;
  final double discount;

  PromoCode({
    required this.id,
    required this.code,
    required this.discount,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['_id'], // Use '_id' instead of 'id'
      code: json['code'],
      discount:
          json['discount'].toDouble(), // Ensure discount is parsed as double
    );
  }
}
