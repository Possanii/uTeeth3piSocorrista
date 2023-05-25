import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmergencyAccept extends StatefulWidget {
  const EmergencyAccept({Key? key}) : super(key: key);

  @override
  State<EmergencyAccept> createState() => _EmergencyAcceptState();
}

class _EmergencyAcceptState extends State<EmergencyAccept> {

  var user = FirebaseAuth.instance.currentUser;

  Future<void> getAllEmergencyAccept()async {
    var doc = await FirebaseFirestore.instance.collection("Chamados").where("uidSocorrista", isEqualTo: user?.uid).where('emergencyAcceptBy', isNotEqualTo: null);

    print(doc);
  }

  @override
  Widget build(BuildContext context) {

    getAllEmergencyAccept();

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }
}
