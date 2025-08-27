import 'package:flutter/material.dart';

class LocationData {
  final TextEditingController location;
  final double lat;
  final double lng;
  final double? radius;
  LocationData({
    required this.location,
    required this.lat,
    required this.lng,
    this.radius,
  });

  factory LocationData.init() =>
      LocationData(location: TextEditingController(), lat: 0, lng: 0);
}
