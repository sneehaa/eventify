class Venue {
  final String name;
  final String date;
  final String time;
  final String price;

  Venue({
    required this.name,
    required this.date,
    required this.time,
    required this.price,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      name: json['name'],
      date: json['date'],
      time: json['time'],
      price: json['price'],
    );
  }
}
