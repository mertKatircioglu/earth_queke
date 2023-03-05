import 'dart:async';
import 'dart:collection';
import 'package:earth_queke/global/globals.dart';
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
  double distance = 0.0;
  LatLng? location;
  bool viewLocation = false;
  Set<Circle> circles ={};
  bool _redCircles = true;
  Color? color;
  Set<Polygon> _polygons = HashSet<Polygon>();


  Future<void> getMarkers() async{
  final mapMarkers = await widget.eartQuekeModel!.getQuekeFromUi();
   mapMarkers.forEach((element) {
     setState(() {
       markers.add(Marker(
         markerId: MarkerId(element["title"].toString()),
         position: LatLng(element["lat"] as double, element["lng"] as double), //position of marker
         infoWindow: InfoWindow( //popup info
           title: element["title"].toString(),
           snippet:"Şiddet: ${element["mag"]}",
         ),
         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
       ));

       circles.add(Circle(
         circleId: CircleId(element["title"].toString()),
         fillColor: Colors.red.withOpacity(0.3),
         strokeWidth: 0,
         center: LatLng(element["lat"] as double, element["lng"] as double),
         radius: 40000,));
     });

  });

  }




  @override
  void initState() {
    super.initState();
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
                  child: Text("Alanları Kaldır", style: TextStyle(fontSize: 10, color:Colors.black45),),
                ),
              ),
              Switch.adaptive(
                  value:  _redCircles,
                  onChanged: (newValue) {
                    setState(() {
                      _redCircles = newValue;
                    });
                    circles.clear();

                  })
            ],
          ),
        ],
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon:const Icon(Icons.arrow_back, color: kPrymaryColor,)),
        title:const Text(
          "Anlık Deprem Haritası",
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
          circles: circles,
          initialCameraPosition:const CameraPosition(
              target: LatLng( 39.1667,33.6667),
              zoom: 5.1
          ),
          markers: markers,
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
