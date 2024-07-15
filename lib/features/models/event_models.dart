class Event {
  final String id;
  final String name;
  final DateTime date;
  final String time;
  final String location;
  final double ticketPrice;
  final List<String> images;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.ticketPrice,
    required this.images,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      name: json['eventName'] ?? '',
      date:
          DateTime.parse(json['eventDate'] ?? DateTime.now().toIso8601String()),
      time: json['eventTime'] ?? '',
      location: json['location'] ?? '',
      ticketPrice: (json['ticketPrice'] as num?)?.toDouble() ?? 0.0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
