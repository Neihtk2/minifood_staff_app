import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/map/controller/map_controller.dart';

import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' hide Point;
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/models/route_progress_event.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
import 'package:vietmap_flutter_navigation/views/banner_instruction.dart';
import 'package:vietmap_flutter_navigation/views/bottom_action.dart';
import 'package:vietmap_flutter_navigation/views/navigation_view.dart';

class MapScreen extends StatefulWidget {
  final String destinationAddress;
  const MapScreen({Key? key, required this.destinationAddress})
    : super(key: key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  bool isLoading = true;
  bool isReadyToNavigate = false;
  String? errorMessage;
  final LocationController mapController = Get.put(LocationController());
  List<LatLng> waypoints = [];

  Widget instructionImage = const SizedBox.shrink();
  Widget recenterButton = const SizedBox.shrink();
  RouteProgressEvent? routeProgressEvent;
  MapNavigationViewController? _navigationController;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Khởi tạo các tùy chọn điều hướng
      _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
      _navigationOption.simulateRoute = false;
      _navigationOption.apiKey =
          '506862bb03a3d71632bdeb7674a3625328cb7e5a9b011841';
      _navigationOption.mapStyle =
          "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=506862bb03a3d71632bdeb7674a3625328cb7e5a9b011841";
      _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);

      // Lấy vị trí hiện tại
      LatLng? currentLocation = await mapController.getCurrentLocation();
      if (currentLocation == null) {
        throw Exception('Không thể lấy vị trí hiện tại');
      }

      // Chuyển đổi địa chỉ đích thành tọa độ
      final destinationLocation = await _convertAddressToCoordinates(
        widget.destinationAddress,
      );
      if (destinationLocation == null) {
        throw Exception('Không thể tìm thấy địa chỉ đích');
      }

      print('Vị trí hiện tại: $currentLocation');
      print('Vị trí đích: $destinationLocation');

      setState(() {
        waypoints = [currentLocation, destinationLocation];
        isReadyToNavigate = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi khởi tạo: $e',
        duration: Duration(seconds: 5),
      );
    }
  }

  Future<LatLng?> _convertAddressToCoordinates(String address) async {
    try {
      final LatLng? coordinates = await mapController.getLocation(address);
      if (coordinates == null) {
        Get.snackbar('Lỗi', 'Không tìm thấy tọa độ cho địa chỉ này');
        return null;
      }
      return coordinates;
    } catch (e) {
      print('Lỗi chuyển đổi địa chỉ: $e');
      Get.snackbar('Lỗi', 'Không thể chuyển địa chỉ thành tọa độ: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉ đường đến ${widget.destinationAddress}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang tải bản đồ...'),
                  ],
                ),
              )
            else if (errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Lỗi: $errorMessage', textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: initialize,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              )
            else if (isReadyToNavigate && waypoints.length >= 2)
              NavigationView(
                mapOptions: _navigationOption,
                onMapCreated: (controller) async {
                  _navigationController = controller;
                  try {
                    print('Bắt đầu vẽ tuyến đường với các điểm: $waypoints');
                    await _navigationController?.buildRoute(
                      waypoints: waypoints,
                      profile: DrivingProfile.motorcycle,
                    );
                    print('Đã vẽ tuyến đường thành công');
                    await Future.delayed(Duration(seconds: 1));
                    _navigationController?.startNavigation();
                  } catch (e) {
                    print('Lỗi khi vẽ tuyến đường: $e');
                    Get.snackbar(
                      'Lỗi',
                      'Không thể vẽ tuyến đường: $e',
                      duration: Duration(seconds: 5),
                    );
                  }
                },
                onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
                  setState(() {
                    this.routeProgressEvent = routeProgressEvent;
                  });
                  _setInstructionImage(
                    routeProgressEvent.currentModifier,
                    routeProgressEvent.currentModifierType,
                  );
                },
                onArrival: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text("Hoàn thành"),
                          content: Text("Đơn hàng đã đến"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(
                                  context,
                                ); // Trở về màn hình trước đó
                              },
                              child: Text("Xác nhận"),
                            ),
                          ],
                        ),
                  );
                },
              ),
            if (!isLoading && errorMessage == null && isReadyToNavigate)
              BannerInstructionView(
                routeProgressEvent: routeProgressEvent,
                instructionIcon: instructionImage,
              ),
            if (!isLoading && errorMessage == null && isReadyToNavigate)
              Positioned(
                bottom: 0,
                child: BottomActionView(
                  onStopNavigationCallback: () {
                    setState(() {
                      instructionImage = const SizedBox.shrink();
                      routeProgressEvent = null;
                    });
                    Navigator.pop(context);
                  },
                  recenterButton: recenterButton,
                  controller: _navigationController,
                  routeProgressEvent: routeProgressEvent,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton:
          !isLoading && errorMessage == null && isReadyToNavigate
              ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      _navigationController?.startNavigation();
                    },
                    child: Icon(Icons.navigation),
                    tooltip: 'Bắt đầu điều hướng',
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {
                      _navigationController?.overview();
                    },
                    child: Icon(Icons.map),
                    tooltip: 'Xem tổng quan tuyến đường',
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: () {
                      _navigationController?.recenter();
                    },
                    child: Icon(Icons.my_location),
                    tooltip: 'Trở về vị trí hiện tại',
                  ),
                  SizedBox(height: 10),

                  SizedBox(height: 100),
                ],
              )
              : null,
    );
  }

  _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      try {
        List<String> data = [
          type.replaceAll(' ', '_'),
          modifier.replaceAll(' ', '_'),
        ];
        String path = 'assets/navigation_symbol/${data.join('_')}.svg';
        setState(() {
          instructionImage = SvgPicture.asset(
            path,
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              print('Không tìm thấy icon: $path');
              return Icon(Icons.directions, color: Colors.white);
            },
          );
        });
      } catch (e) {
        print('Lỗi khi đặt hình ảnh chỉ dẫn: $e');
        setState(() {
          instructionImage = Icon(Icons.directions, color: Colors.white);
        });
      }
    }
  }
}
