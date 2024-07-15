import 'package:flutter/material.dart';

class TicketCounts extends ChangeNotifier {
  int generalTicketCount = 0;
  int fanpitTicketCount = 0;
  int vipTicketCount = 0;

  TicketCounts({
    this.generalTicketCount = 0,
    this.fanpitTicketCount = 0,
    this.vipTicketCount = 0,
  });

  factory TicketCounts.fromJson(Map<String, dynamic> json) {
    return TicketCounts(
      generalTicketCount: json['generalTicketCount'] ?? 0,
      fanpitTicketCount: json['fanpitTicketCount'] ?? 0,
      vipTicketCount: json['vipTicketCount'] ?? 0,
    );
  }

  void updateTicketCounts({
    required int generalTickets,
    required int fanpitTickets,
    required int vipTickets,
  }) {
    generalTicketCount = generalTickets;
    fanpitTicketCount = fanpitTickets;
    vipTicketCount = vipTickets;
    notifyListeners();
  }
}
