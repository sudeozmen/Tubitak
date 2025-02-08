/*
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/kullaniciservisi.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class TakipSayfasi extends StatefulWidget {
  const TakipSayfasi({Key? key}) : super(key: key);

  @override
  State<TakipSayfasi> createState() => _TakipSayfasiState();
}

class _TakipSayfasiState extends State<TakipSayfasi> {


  final KullaniciServisi _kullaniciServisi=KullaniciServisi();


  final Completer<GoogleMapController> _controller=Completer();


  //static const LatLng destination=LatLng(40.8233, 29.9254);


  List<LatLng> polylineCoordinates=[];
  LocationData? currentLocation;
  //bool? _serviceEnabled;
  //PermissionStatus? _permissionlocation;
  LocationData? _locData;
  String kullaniciID="";
  String telefon="";



  void getSourceLocation() async {

    Location location= Location();

    // konum bilgisi için izin
    /*_serviceEnabled=await location.serviceEnabled();
    if(!_serviceEnabled!){
      _serviceEnabled=await location.requestService();
      if(!_serviceEnabled!){
        return;
      }
    }

    _permissionlocation=await location.hasPermission();
    if(_permissionlocation==PermissionStatus.denied){
      _permissionlocation=await location.requestPermission();
      if(_permissionlocation!=PermissionStatus.granted){
        return;
      }
    }*/

    _locData=await location.getLocation();
    GeoPoint geoPoint=GeoPoint(_locData!.latitude!,_locData!.longitude!);

    _kullaniciServisi.add(kullaniciID, telefon, geoPoint);

  }


  void getCurrentLocation() async{
    Location location=Location();
    location.getLocation().then(
            (location) {
          currentLocation=location;
        });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation=newLoc;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 150.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              )
          ),
        ),
      );
    });
  }


  @override
  void initState(){
    super.initState();
    getCurrentLocation();
    getSourceLocation();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          "ATIK TAKİP",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white70,
              fontSize: 20),
        ),
      ),
      body:
      currentLocation==null
          ? const Center(child: Text("Yükleniyor"))
          : GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition:
        CameraPosition(
            target: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
            zoom: 13.5),
        markers: {
          Marker(
              infoWindow: const InfoWindow(title: 'Anlık Konum'),
              markerId: const MarkerId("currentLocation"),
              position: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!)
          ),
          Marker(
            infoWindow: const InfoWindow(title: 'Çıkış Noktası'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            markerId: const MarkerId("source"),
            position: LatLng(
                _locData!.latitude!,
                _locData!.longitude!),
          ),
          Marker(
            infoWindow: const InfoWindow(title: 'Varış Noktası'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            markerId: const MarkerId("destination"),
            position:LatLng(_locData!.latitude!, _locData!.longitude!),
          ),
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },

      ),

    );
  }


}

*/