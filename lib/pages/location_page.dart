import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uteeth_socorrista/pages/rate_emergency_page.dart';

class LocationPage extends StatefulWidget {
  var id;

  LocationPage({Key? key, required this.id}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  late String uid;
  late String phone;
  late double lat;
  late double long;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _fazerChamada() async {
    await FirebaseFirestore.instance
        .collection("Chamados")
        .doc(widget.id)
        .get()
        .then((value) => uid = value.data()?['uidDentista']);

    await FirebaseFirestore.instance
        .collection('dentista')
        .doc(uid)
        .get()
        .then((value) => phone = "tel:" + value.data()?['phone']);

    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Não foi possível fazer a chamada: $phone';
    }
  }

  _abrirGoogleMaps() async {
    var url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o Google Maps: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Localização",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(4, 9, 87, 1),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Chamados")
                    .doc(widget.id)
                    .collection('localização')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      lat = double.parse(
                          snapshot.data?.docs[0].data()['latitude']);
                      long = double.parse(
                          snapshot.data?.docs[0].data()['longitude']);
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 550,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 15.0,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('Market'),
                                    position: LatLng(lat, long),
                                  ),
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _abrirGoogleMaps,
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(4, 9, 87, 1),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Abrir Google Maps",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: _fazerChamada,
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(4, 9, 87, 1),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Fazer Ligação",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RateEmergencyPage(
                                    id: widget.id,
                                  ),
                                ),
                              ),
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(4, 9, 87, 1),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Avaliar chamado",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Algum erro aconteceu!",
                        style: TextStyle(fontSize: 16),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Aguardando localização.",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _fazerChamada,
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(4, 9, 87, 1),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Fazer Ligação",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
