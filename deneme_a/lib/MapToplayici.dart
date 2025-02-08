/*import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme_a/kullaniciservisi.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapToplayici extends StatefulWidget {
  const MapToplayici({Key? key}) : super(key: key);

  @override
  State<MapToplayici> createState() => _MapToplayiciState();
}



class _MapToplayiciState extends State<MapToplayici> {



  final Completer<GoogleMapController> _controller=Completer();
  final KullaniciServisi _kullaniciServisi=KullaniciServisi();
  String kullaniciID="";
  String telefon="";
  LocationData? _loc;
  LatLng? d;
  double? lat;
  double? long;


  void getSourceLoc() async{
    Location location= Location();
    location.getLocation().then((value) =>{
      lat=value.latitude,
      long=value.longitude
    });
    _loc!= await location.getLocation();
    GeoPoint geoPoint=GeoPoint(_loc!.latitude!,_loc!.longitude!);
    _kullaniciServisi.add(kullaniciID, telefon, geoPoint);
  }


  useData(){
    _kullaniciServisi.getData().then((value){
      setState(() {
        value=d;
      });
    });
  }


  @override
  void initState(){
    super.initState();
    getSourceLoc();
    useData();
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
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition:
        CameraPosition(
          target: LatLng(_loc!.latitude!,_loc!.longitude!),
          zoom:13.5,),
        markers: {
          Marker(
            markerId: const MarkerId("source"),
            infoWindow: const InfoWindow(title: 'Çıkış Noktası'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            position: LatLng(_loc!.latitude!,_loc!.longitude!),
          ),
          Marker(
            markerId: const MarkerId('Hedef Nokta'),
            infoWindow: const InfoWindow(title: 'Hedef Nokta'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position:LatLng(d!.latitude,d!.longitude),
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