import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pwowd = TextEditingController();

  login() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pwowd.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == email.text) {
        print('No user found for that email.');
      } else if (e.code == pwowd.text) {
        print('Wrong password provided for that user.');
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => RegisterScreen()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: email,
              ),
              TextFormField(
                controller: pwowd,
              ),
              ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: const Text('LOGIN'))
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MapScreen> createState() => MapScreenState();
// }
//
// class MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//
//   //geoLocator Start
//   getCurrentPosidion() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       print('Permission Not Given');
//       LocationPermission asked = await Geolocator.requestPermission();
//     } else {
//       Position currentPermission = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//       print('LATITUTE' + currentPermission.latitude.toString());
//       print('LONGTITUTE' + currentPermission.longitude.toString());
//       return [
//         currentPermission.latitude.toString(),
//         currentPermission.longitude.toString()
//       ];
//     }
//   }
//
//   //geoLocator End
//   static var lat = 24.91;
//   static var long = 67.05;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   static CameraPosition _kGooglePlex = CameraPosition(
//     // target: LatLng(37.42796133580664, -122.085749655962),
//     target: LatLng(lat, long),
//     zoom: 14.4746,
//   );
//
//   static CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       // target: LatLng(37.43296265331129, -122.08832357078792),
//       target: LatLng(lat, long),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('AMBULANCE'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 getCurrentPosidion().then((value) {
//                   print(value);
//                   print(lat);
//                   print(value[0]);
//                   print(lat.runtimeType);
//                   print(double.parse(value[0]).runtimeType);
//                   setState(() {
//                     lat = double.parse(value[0]);
//                     long = double.parse(value[1]);
//                     _kGooglePlex = CameraPosition(
//                       // target: LatLng(37.42796133580664, -122.085749655962),
//                       target: LatLng(lat, long),
//                       zoom: 14.4746,
//                     );
//                     _kLake = CameraPosition(
//                         bearing: 192.8334901395799,
//                         // target: LatLng(37.43296265331129, -122.08832357078792),
//                         target: LatLng(lat, long),
//                         tilt: 59.440717697143555,
//                         zoom: 19.151926040649414);
//                   });
//                 });
//               },
//               child: Text('Geo Locator')),
//           Expanded(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: _kGooglePlex,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
