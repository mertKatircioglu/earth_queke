import 'dart:async';

import 'package:earth_queke/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/data_model.dart';


class ItemDetailWidget extends StatefulWidget {
  DataModel? earthQuakeViewModel;
   ItemDetailWidget({Key? key, this.earthQuakeViewModel}) : super(key: key);

  @override
  State<ItemDetailWidget> createState() => _ItemDetailWidgetState();
}

class _ItemDetailWidgetState extends State<ItemDetailWidget> {

  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> markers = {};
  double distance = 0.0;
  LatLng? location;
  bool viewLocation = false;
  Set<Circle> circles ={};

  @override
  void initState() {
    location = LatLng(
        (widget.earthQuakeViewModel!.lat as double),
        (widget.earthQuakeViewModel!.lng as double));
    circles.add(Circle(
      circleId: CircleId(widget.earthQuakeViewModel!.title.toString()),
      fillColor: Colors.red!.withOpacity(0.3),
        strokeWidth: 0,
      center: LatLng(widget.earthQuakeViewModel!.lat as double, widget.earthQuakeViewModel!.lng as double),
      radius: 15000,));

    markers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location!, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'Deprem Bölgesi',
        snippet: widget.earthQuakeViewModel!.mag.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    super.initState();
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
                  height: 100,
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
                    trafficEnabled: true,
                    circles: circles,
                    initialCameraPosition: CameraPosition(
                        target: location!,
                        zoom: 10.0
                    ),
                    markers: markers,
                    mapType: MapType.hybrid,
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
