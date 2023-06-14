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
    var latitude = lat.toString();
    var longitude = lat.toString();

    var url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

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
                    lat =
                        double.parse(snapshot.data?.docs[0].data()['latitude']);
                    long = double.parse(
                        snapshot.data?.docs[0].data()['longitude']);
                    return Column(
                      children: [
                        SizedBox(
                          width: 400,
                          height: 550,
                          child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(lat, long),
                                zoom: 15.0,
                              ),
                              markers: {
                                Marker(
                                    markerId: const MarkerId('Market'),
                                    position: LatLng(lat, long))
                              }),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _abrirGoogleMaps(),
                              child: const Text("Abrir Google Maps"),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              child: Text('Fazer Ligação'),
                              onPressed: _fazerChamada,
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
                                      )),
                            ),
                          },
                          child: const Text("Avaliar chamado"),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Algum erro aconteceu!");
                  } else {
                    return Center(
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Aguardando localização."),
                          SizedBox(height: 20),
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text('Fazer Ligação'),
                            onPressed: _fazerChamada,
                          ),
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
