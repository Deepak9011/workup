class Bid {
  final String bidId;
  final String customerId;
  final String serviceProviderId;
  final String startBidTime;
  final String endBidTime;
  final String serviceTime;
  final String category;
  final String description;
  final double maxAmount;
  final String address;
  final String state;
  final String country;
  final String additionalNotes;
  final String bidStatus;
  final String? conformCustomerId;

  Bid({
    required this.bidId,
    required this.customerId,
    required this.serviceProviderId,
    required this.startBidTime,
    required this.endBidTime,
    required this.serviceTime,
    required this.category,
    required this.description,
    required this.maxAmount,
    required this.address,
    required this.state,
    required this.country,
    required this.additionalNotes,
    required this.bidStatus,
    this.conformCustomerId,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      bidId: json['bidId'],
      customerId: json['customerId'],
      serviceProviderId: json['serviceProviderId'],
      startBidTime: json['startBidTime'],
      endBidTime: json['endBidTime'],
      serviceTime: json['serviceTime'],
      category: json['category'],
      description: json['description'],
      maxAmount: (json['maxAmount'] as num).toDouble(),
      address: json['address'],
      state: json['state'],
      country: json['country'],
      additionalNotes: json['additionalNotes'],
      bidStatus: json['bidStatus'],
      conformCustomerId: json['conformCustomerId'],
    );
  }
}
