import 'package:get/get.dart';
import 'package:minifood_staff/core/services/vietmap_service.dart';
import 'package:minifood_staff/data/models/location_model.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final VietMapService _vietMapService = VietMapService();
  var suggestions = <LocationSuggestion>[].obs;
  var isLoading = false.obs;
  var selectedLocation = Rxn<LocationSuggestion>();
  var currentPosition = Rxn<Position>();
  var mapController = Rxn<VietmapController>();
  var showConfirmButton = false.obs;
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

  void selectLocation(LocationSuggestion location) {
    selectedLocation.value = location;
    suggestions.clear();
    if (selectedLocation.value != null) {
      // final name = selectedLocation.value!.name;
      // final address = selectedLocation.value!.address;

      mapController.value!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 15,
          ),
        ),
      );
      // final fullAddress = [
      //   if (name != null && name.isNotEmpty) name,
      //   if (address != null && address.isNotEmpty) address,
      // ].join(', ');
      // Get.back(result: address); // Gửi địa chỉ về CheckoutForm

      // addMarkerAtLocation();
    }
  }

  // Future<void> getCurrentLocation() async {
  //   isLoading.value = true;
  //   try {
  //     // Check location permission
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         Get.snackbar('Error', 'Location permissions are denied');
  //         return;
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       Get.snackbar('Error', 'Location permissions are permanently denied');
  //       return;
  //     }

  //     // Get current position
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     currentPosition.value = position;
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to get current location: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<LatLng?> getCurrentLocation() async {
    try {
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
