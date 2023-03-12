import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map2Screen extends StatefulWidget {
  const Map2Screen({Key? key}) : super(key: key);

  @override
  State<Map2Screen> createState() => _Map2ScreenState();
}

class _Map2ScreenState extends State<Map2Screen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(24.913838, 67.059419));

  final List<Marker> _marker = <Marker>[
    // Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(24.913838, 67.059419),
    //     infoWindow: InfoWindow(title: 'The Tittle of The Marker'))
  ];
  Future<Position> gerUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) => null)
        .onError((error, stackTrace) {
      print('error' + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          gerUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + "" + value.longitude.toString());
            _marker.add(
              Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(title: 'Please Heip Me')),
            );
            CameraPosition cameraPosition = CameraPosition(
                zoom: 17, target: LatLng(value.latitude, value.longitude));
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        label: Text('Current Location'),
      ),
    );
  }
}
