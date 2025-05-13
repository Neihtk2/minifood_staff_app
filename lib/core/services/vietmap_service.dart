import 'package:dio/dio.dart';
import 'package:minifood_staff/data/models/location_model.dart';

class VietMapService {
  final Dio _dio = Dio();

  final String _apiKey = '5ce0e35c4e0bdd0373a8532b329869a2330edc4ef4c5b24e';

  Future<List<LocationSuggestion>> getLocationSuggestions(String query) async {
    try {
      final response = await _dio.get(
        'https://maps.vietmap.vn/api/search',
        queryParameters: {'apikey': _apiKey, 'text': query},
      );

      if (response.statusCode == 200 &&
          response.data['code'] == 'OK' &&
          response.data['data']?['features'] is List) {
        final List<dynamic> features = response.data['data']['features'];

        return features.map((item) {
          final geometry = item['geometry'];
          final properties = item['properties'];

          return LocationSuggestion(
            name: properties['name'] ?? '',
            address: properties['label'] ?? '',
            latitude: geometry?['coordinates']?[1] ?? 21.03195524000006,
            longitude: geometry?['coordinates']?[0] ?? 105.85323767000006,
          );
        }).toList();
      }

      return [];
    } catch (e) {
      print('Error getting suggestions: $e');
      return [];
    }
  }

  Future<LocationSuggestion?> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      final response = await _dio.get(
        'https://maps.vietmap.vn/api/reverse/v3',
        queryParameters: {
          'apikey': _apiKey,
          'lng': lng.toString(),
          'lat': lat.toString(),
        },
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        final properties = response.data[0];
        return LocationSuggestion(
          name: properties['name'],
          address: properties['address'],
          latitude: lat,
          longitude: lng,
        );
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }
}
