import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //geoLocator Start
  getCurrentPosidion() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Permission Not Given');
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentPermission = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print('LATITUTE' + currentPermission.latitude.toString());
      print('LONGTITUTE' + currentPermission.longitude.toString());
      return [
        currentPermission.latitude.toString(),
        currentPermission.longitude.toString()
      ];
    }
  }

  //geoLocator End
  // var lat = 24.913838;
  // var long z
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   var lat = 24.913838;
  //   var long = 24.913838;
  // }

  static CameraPosition _kGooglePlex = CameraPosition(
    // target: LatLng(37.42796133580664, -122.085749655962),
    target: LatLng(24.913838, 67.059419),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      // target: LatLng(37.43296265331129, -122.08832357078792),
      target: LatLng(24.913838, 67.059419),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('AMBULANCE'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                getCurrentPosidion().then((value) {
                  print(value);
                });
              },
              child: Text('Geo Locator')),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
