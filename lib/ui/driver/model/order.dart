class Order {
  final String id;
  final Buyer buyer;
  final Listing listing;
  final String deliveryStatus;
  final String locationName;
  final Driver? driver; // optional, can be null

  Order({
    required this.id,
    required this.buyer,
    required this.listing,
    required this.deliveryStatus,
    required this.locationName,
    this.driver,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['_id'] ?? '',
        buyer: Buyer.fromJson(json['buyer']),
        listing: Listing.fromJson(json['listing']),
        deliveryStatus: json['deliveryStatus'] ?? '',
        locationName: json['locationName'] ?? '',
        driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      );
}

class Buyer {
  final String id;
  final String displayName;
  Buyer({required this.id, required this.displayName});

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
        id: json['_id'] ?? '',
        displayName: json['displayName'] ?? '',
      );
}

class Listing {
  final String id;
  final String title;
  Listing({required this.id, required this.title});

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
      );
}

class Driver {
  final String id;
  final String userId; // this matches backend driver.user
  final String licenseNumber;
  final String vehicle;

  Driver({
    required this.id,
    required this.userId,
    required this.licenseNumber,
    required this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['_id'] ?? '',
        userId: json['user'] ?? '', // backend returns string
        licenseNumber: json['licenseNumber'] ?? '',
        vehicle: json['vehicle'] ?? '',
      );
}
