class LocationSuggestion {
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;

  LocationSuggestion({this.name, this.address, this.latitude, this.longitude});

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      name: json['name'],
      address: json['address'],
      latitude:
          json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      longitude:
          json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
    );
  }

  @override
  String toString() {
    return name ?? address ?? 'Unknown location';
  }
}
