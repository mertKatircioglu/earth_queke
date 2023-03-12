import 'dart:async';

import 'package:earth_queke/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../model/data_model.dart';


class ItemDetailWidget extends StatefulWidget {
  DataModel? earthQuakeViewModel;
   ItemDetailWidget({Key? key, this.earthQuakeViewModel}) : super(key: key);

  @override
  State<ItemDetailWidget> createState() => _ItemDetailWidgetState();
}

class _ItemDetailWidgetState extends State<ItemDetailWidget> {

  Completer<GoogleMapController> mapController = Completer();

  double distance = 0.0;
  LatLng? locationArea;
  LatLng? locationAirPort;
  bool viewLocation = false;
  Set<Circle> circles ={};
  Map<PolylineId, Polyline> polylines = {};
  String googleAPiKey = "AIzaSyCEuddEUTRs7CCLImBYeATHCEXM8u8SK-8";
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];




  @override
  void initState() {
    super.initState();
    locationArea = LatLng(
        widget.earthQuakeViewModel!.geojson!.coordinates![1],
        widget.earthQuakeViewModel!.geojson!.coordinates![0]
    );
    locationAirPort = LatLng(
      widget.earthQuakeViewModel!.locationProperties!.airports![0].coordinates!.coordinates![1],
      widget.earthQuakeViewModel!.locationProperties!.airports![0].coordinates!.coordinates![0],
    );
    circles.add(Circle(
      circleId: CircleId(widget.earthQuakeViewModel!.title.toString()),
      fillColor: Colors.red.withOpacity(0.3),
      strokeWidth: 0,
      center: LatLng(widget.earthQuakeViewModel!.geojson!.coordinates![1], widget.earthQuakeViewModel!.geojson!.coordinates![0]),
      radius: 15000,));
    _getPolyline();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      width: 8,
        polylineId: id, color: Colors.deepPurpleAccent, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(locationArea!.latitude, locationArea!.longitude),
        PointLatLng(locationAirPort!.latitude, locationAirPort!.longitude),
        travelMode: TravelMode.driving,);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBackGroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context,true);
        },
            icon:const Icon(Icons.arrow_back, color: kPrymaryColor,)),
        title: Text(widget.earthQuakeViewModel!.title.toString(), style:const TextStyle(
            color: kPrymaryColor,
            fontSize: 18
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: kBackGroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Şiddeti: ", style: TextStyle(
                                  color: kPrymaryColor,
                                  fontSize: 14
                              ),),
                              Text('${widget.earthQuakeViewModel!.mag} mag', style: const TextStyle(
                                  fontSize: 14
                              ),),
                            ],
                          ),
                          const Divider(
                            height: 8,
                            thickness: 0.2,
                            color: kPrymaryColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Derinlik: ", style: TextStyle(
                                  color: kPrymaryColor,
                                  fontSize: 14
                              ),),
                              Text('${widget.earthQuakeViewModel!.depth} km', style: const TextStyle(
                                  fontSize: 14
                              ),),
                            ],
                          ),
                          const Divider(
                            height: 8,
                            thickness: 0.2,
                            color: kPrymaryColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Tarih-Saat: ", style: TextStyle(
                                  color: kPrymaryColor,
                                  fontSize: 14
                              ),),
                              Text(widget.earthQuakeViewModel!.date.toString(), style: const TextStyle(
                                  fontSize: 14
                              ),),
                            ],
                          ),
                          const Divider(
                            height: 8,
                            thickness: 0.2,
                            color: kPrymaryColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("En Yakın Hava Alanı: ", style: TextStyle(
                                  color: kPrymaryColor,
                                  fontSize: 14
                              ),),
                              InkWell(
                                onTap: (){
                                  MapsLauncher.launchCoordinates(
                                      widget.earthQuakeViewModel!.locationProperties!.airports![0].coordinates!.coordinates![1],
                                      widget.earthQuakeViewModel!.locationProperties!.airports![0].coordinates!.coordinates![0],
                                      widget.earthQuakeViewModel!.locationProperties!.airports![0].name);
                                },
                                child: Row(
                                  children: [
                                    Text('${widget.earthQuakeViewModel!.locationProperties!.airports![0].name}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      color: Colors.blue
                                    ),),
                                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.blue,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 8,
                            thickness: 0.2,
                            color: kPrymaryColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("En Yakın İl Sınırı: ", style: TextStyle(
                                  color: kPrymaryColor,
                                  fontSize: 14
                              ),),
                              Text('${widget.earthQuakeViewModel!.locationProperties!.closestCity!.name}', style: const TextStyle(
                                  fontSize: 14
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    trafficEnabled: true,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    circles: circles,
                    initialCameraPosition: CameraPosition(
                        target: locationArea!,
                        zoom: 9.0
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(locationArea.toString()),
                        position: locationArea!,
                        infoWindow: InfoWindow( //popup info
                          title: 'Deprem Bölgesi',
                          snippet: widget.earthQuakeViewModel!.mag.toString(),
                        ),
                        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                      ),
                      Marker(
                        markerId: MarkerId(locationAirPort.toString()),
                        position: locationAirPort!, //position of marker
                        infoWindow: InfoWindow( //popup info
                          title: widget.earthQuakeViewModel!.locationProperties!.airports![0].name,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(100), //Icon for Marker
                      )
                    },
                    polylines: Set<Polyline>.of(polylines.values),

                    mapType: MapType.normal,
                    onMapCreated: (controller){
                      setState((){
                        mapController.complete(controller);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
