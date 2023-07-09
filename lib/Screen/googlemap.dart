import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/provider/location_provider.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';
import 'no_internet_screen.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Marker> _marker = [];

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  double? lat;
  double? long;
  String address = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('in service enabled start');
      Geolocator.openLocationSettings().then((value) {
        print('open location setting : $value');
      });
      await Geolocator.requestPermission().then((value) {
        print('request permission : $value');
      });
      Fluttertoast.showToast(msg: 'Location Service are disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location Service are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Fluttertoast.showToast(msg: 'Location Service are permanently denied');

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    }

    return await Geolocator.getCurrentPosition();
  }

  getLocation() {
    LatLng _latlng = LatLng(0, 0);

    _determinePosition().then((value) {
      print("${value.latitude} + hello");
      print('latlng on get location : $value');
      _latlng = LatLng(lat = value.latitude, long = value.longitude);
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat = value.latitude, long = value.longitude),
        zoom: 14,
      );

      _getAddressFromLatLng(LatLng(value.latitude, value.longitude));
      setState(() {
        newGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    }).whenComplete(() {
      print('lat long : $_latlng');
      Marker marker = Marker(
        markerId: MarkerId("test"),
        position: _latlng,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      );

      _marker.add(marker);
      setState(() {});
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    print(position);
    List<Placemark> _placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    print(_placeMark);
    Placemark place = _placeMark[0];
    if (mounted) {
      setState(() {
        address =
            "${place.street}, ${place.subLocality}, ${place.locality} (${place.postalCode}), ${place.country}.";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(21.7128, 75.0060),
                    zoom: (10.0),
                  ),
                  onTap: (LatLng latlng) {
                    Marker marker = Marker(
                      markerId: MarkerId("test"),
                      position: latlng,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    );
                    _getAddressFromLatLng(
                        LatLng(latlng.latitude, latlng.longitude));
                    _marker.add(marker);
                    setState(() {});
                  },
                  markers: _marker.map((e) => e).toSet(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    newGoogleMapController = controller;
                    getLocation();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("$address"),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  side: MaterialStateProperty.all(
                                      BorderSide.none),
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomTheme.primarycolor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () {
                                Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .setAddress(
                                        addressData: address,
                                        latData: lat.toString(),
                                        longData: long.toString());
                                Navigator.of(context).pop();
                              },
                              child: Text("Set your Location",
                                  style:
                                      CustomTheme.body1.copyWith(fontSize: 15)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink(),
      ],
    );
  }
}
