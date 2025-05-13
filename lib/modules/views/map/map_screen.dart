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
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();
  final LocationController mapController = Get.put(LocationController());
  List<LatLng> waypoints = [
    LatLng(21.027763, 105.911111),
    LatLng(21.024222, 105.770444),
    // LatLng(20.969712, 105.798019),
  ];

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
    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();

    _navigationOption.simulateRoute = false;

    _navigationOption.apiKey =
        '506862bb03a3d71632bdeb7674a3625328cb7e5a9b011841';
    _navigationOption.mapStyle =
        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=506862bb03a3d71632bdeb7674a3625328cb7e5a9b011841";

    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
    // LatLng? current = await mapController.getCurrentLocation();
    // if (current != null) {
    //   setState(() {
    //     waypoints.insert(0, current);
    //   });
    // } else {
    //   setState(() {
    //     waypoints.insert(1, LatLng(21.024222, 105.770444));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // hàm build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            NavigationView(
              mapOptions: _navigationOption,
              onMapCreated: (controller) async {
                _navigationController = controller;
                await _navigationController?.buildRoute(
                  waypoints: waypoints,
                  profile: DrivingProfile.motorcycle,
                );
                _navigationController?.startNavigation();
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
                              setState(() {
                                instructionImage = const SizedBox.shrink();
                                routeProgressEvent = null;
                              });
                            },
                            child: Text("Xác nhận"),
                          ),
                        ],
                      ),
                );
              },
            ),
            BannerInstructionView(
              routeProgressEvent: routeProgressEvent,
              instructionIcon: instructionImage,
            ),
            Positioned(
              bottom: 0,
              child: BottomActionView(
                onStopNavigationCallback: () {
                  setState(() {
                    instructionImage = const SizedBox.shrink();
                    routeProgressEvent = null;
                  });
                },
                recenterButton: recenterButton,
                controller: _navigationController,
                routeProgressEvent: routeProgressEvent,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _navigationController?.startNavigation();
            },
            child: Icon(Icons.directions),
          ),
          FloatingActionButton(
            onPressed: () {
              _navigationController?.overview();
            },
            child: Icon(Icons.route),
          ),
          FloatingActionButton(
            onPressed: () {
              _navigationController?.recenter();
            },
            child: Icon(Icons.directions),
          ),
          FloatingActionButton(
            onPressed: () {
              _navigationController?.finishNavigation();
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      List<String> data = [
        type.replaceAll(' ', '_'),
        modifier.replaceAll(' ', '_'),
      ];
      String path = 'assets/navigation_symbol/${data.join('_')}.svg';
      setState(() {
        instructionImage = SvgPicture.asset(path, color: Colors.white);
      });
    }
  }
}
