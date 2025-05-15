import 'package:get/get.dart';
import 'package:minifood_staff/core/services/vietmap_service.dart';
import 'package:minifood_staff/data/models/location_model.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final VietMapService _repo = VietMapService.instance;
  var suggestions = <LocationSuggestion>[].obs;
  var isLoading = false.obs;
  var selectedLocation = Rxn<LocationSuggestion>();
  var currentPosition = Rxn<Position>();
  var mapController = Rxn<VietmapController>();
  void setMapController(VietmapController controller) {
    mapController.value = controller;
  }

  String removeDuplicateWords(String input) {
    final parts = input.split(',').map((e) => e.trim()).toList();

    for (int i = 0; i < parts.length - 1; i++) {
      if (parts[i] == parts[i + 1]) {
        parts.removeAt(i + 1);
        break;
      }
    }

    return parts.join(', ');
  }

  Future<LatLng?> getLocation(String location) async {
    try {
      isLoading.value = true;
      final position = await _repo.getExactLocation(location);
      if (position != null &&
          position.latitude != null &&
          position.longitude != null) {
        return LatLng(position.latitude!, position.longitude!);
      } else {
        Get.snackbar('Lỗi', 'Không tìm thấy tọa độ từ địa chỉ.');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
      return null;
    }
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      isLoading.value = true;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
      return null;
    }
  }
}
