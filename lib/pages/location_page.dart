import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  var id;

  LocationPage({Key? key, required this.id}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localização"),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Chamados")
                  .doc(widget.id)
                  .collection('localização')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Container(
                      width: 400,
                      height: 700,
                      child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.parse(
                                    snapshot.data?.docs[0].data()['latitude']),
                                double.parse(snapshot.data?.docs[0]
                                    .data()['longitude'])),
                            zoom: 15.0,
                          ),
                          markers: {
                            Marker(
                                markerId: const MarkerId('Market'),
                                position: LatLng(
                                    double.parse(snapshot.data?.docs[0]
                                        .data()['latitude']),
                                    double.parse(snapshot.data?.docs[0]
                                        .data()['longitude'])))
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Algum erro aconteceu!");
                  } else {
                    return const Center(
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Aguardando localização."),
                          SizedBox(height: 20),
                          CircularProgressIndicator()
                        ],
                      )),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ]),
      )),
    );
  }
}
