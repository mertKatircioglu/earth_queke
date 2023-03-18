import 'dart:async';
import 'dart:collection';
import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/main.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapsWdiget extends StatefulWidget {
  EarthQuakeViewModel? eartQuekeModel;
   MapsWdiget({Key? key, this.eartQuekeModel}) : super(key: key);

  @override
  State<MapsWdiget> createState() => _MapsWdigetState();
}

class _MapsWdigetState extends State<MapsWdiget> {

  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> markers = {};
  Set<Marker> markersBlank = {};
  double distance = 0.0;
  LatLng? location;
  bool viewLocation = false;
  Set<Circle> circles ={};
  bool _showPin = false;
  Color? color;
  BitmapDescriptor? customIcon;


  Future<void> getMarkers() async{
  final mapMarkers = await widget.eartQuekeModel!.getQuekeFromUi();
   mapMarkers.forEach((element) {
     markers.add(Marker(
       markerId: MarkerId(element["title"].toString()),
       position: LatLng(element["geojson"]['coordinates'][1] as double,element["geojson"]['coordinates'][0] as double), //position of marker
       infoWindow: InfoWindow( //popup info
         title: element["title"].toString(),
         snippet:"Şiddet: ${element["mag"]}",
       ),
       icon: BitmapDescriptor.defaultMarker
     ));

     circles.add(Circle(
       strokeColor: Colors.black87,
       circleId: CircleId(element["title"].toString()),
       fillColor: element["mag"] <= 2.0 ? Colors.yellow : element["mag"] <=3.0 ? Colors.orange:
       element["mag"] <= 4.0 ? Colors.deepOrange : element["mag"] <= 5.0 ? Colors.purple
           :element["mag"] <= 6.0 ? Colors.red: element["mag"] <= 7.0 ? Colors.red.shade700 : Colors.red.shade900,
       strokeWidth: 2,
       center: LatLng(element["geojson"]['coordinates'][1] as double,element["geojson"]['coordinates'][0] as double),
       radius: (element["mag"] * 5500).toDouble(),));
     setState(() {});

  });
  }




  @override
  void initState() {
    super.initState();
/*    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)),
        'images/pin.png')
        .then((d) {
      customIcon = d;
    });*/
    getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackGroundColor,
        actions: [
          Row(
            children: [
              const SizedBox(width: 1),
              Container(
                height: 50,
                child:const Center(
                  child: Text("Pin Göster", style: TextStyle(fontSize: 10, color:Colors.black45),),
                ),
              ),
              Switch.adaptive(
                  value:  _showPin,
                  onChanged: (newValue) {
                    setState(() {
                      _showPin = newValue;
                    });


                  })
            ],
          ),
        ],
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon:const Icon(Icons.arrow_back, color: kPrymaryColor,)),
        title:const Text(
          "Deprem Haritası",
          style: TextStyle(
            color: kPrymaryColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          trafficEnabled: true,
          circles:circles,
          initialCameraPosition:const CameraPosition(
              target: LatLng( 39.1667,33.6667),
              zoom: 5.1
          ),
          markers:_showPin == true ? markers : markersBlank,
          mapType: MapType.hybrid,
          onMapCreated: (controller){
            setState((){
              mapController.complete(controller);
            });
          },
        ),
      ),
    );
  }
}
