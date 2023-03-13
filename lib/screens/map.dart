import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image/image.dart' as image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(24.913838, 67.059419));

  String imagePath = '';

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

  Future<ui.Image> getUiImage(
      String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    image.Image? baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List());
    image.Image resizeImage =
        image.copyResize(baseSizeImage!, height: height, width: width);
    ui.Codec codec =
        await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    const double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    const double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    const double borderWidth = 3.0;

    const double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(
                shadowWidth,
                shadowWidth,
                size.width - (shadowWidth * 2),
                size.height - (shadowWidth * 2)),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = const TextSpan(
        text: '1', style: TextStyle(fontSize: 20.0, color: Colors.white));

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width - tagWidth / 2 - textPainter.width / 2,
            tagWidth / 2 - textPainter.height / 2));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    // ui.Image image = await getImageFromPath(imagePath); // Alternatively use your own method to get the image
    ui.Image image = await getUiImage(imagePath, 150,
        150); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? uint8List = byteData?.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List!);
  }

  Future<void> setMarker({required final String imagePath}) async {
    final Position value = await gerUserCurrentLocation();
    _marker.clear();
    debugPrint("${value.latitude}${value.longitude}");
    _marker.add(
      Marker(
          markerId: const MarkerId('1'),
          icon: await getMarkerIcon(imagePath, const Size(150.0, 150.0)),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: 'Please Help Me')),
    );
    CameraPosition cameraPosition = CameraPosition(
        zoom: 17, target: LatLng(value.latitude, value.longitude));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.add_chart,
        activeIcon: Icons.emergency_share_outlined,
        buttonSize: const Size(70, 70),
        visible: true,
        closeManually: false,
        renderOverlay: true,
        curve: Curves.easeInBack,
        overlayColor: Colors.black,
        direction: SpeedDialDirection.up,
        children: [
          SpeedDialChild(
            label: 'Ambulance',
            onTap: () async {
              await setMarker(imagePath: 'assets/pic/ambulance.png');
            },
            child: Image.asset('assets/pic/ambulance.png'),
          ),
          SpeedDialChild(
            label: 'Fire',
            onTap: () async {
              await setMarker(imagePath: 'assets/pic/fire.png');
            },
            child: Image.asset('assets/pic/fire.png'),
          ),
          SpeedDialChild(
            label: 'Police',
            onTap: () async {
              await setMarker(imagePath: 'assets/pic/police.png');
            },
            child: Image.asset('assets/pic/police.png'),
          ),
        ],
      ),
    );
  }
}
