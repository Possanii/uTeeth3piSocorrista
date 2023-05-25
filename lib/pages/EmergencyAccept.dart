import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmergencyAccept extends StatefulWidget {
  const EmergencyAccept({Key? key}) : super(key: key);

  @override
  State<EmergencyAccept> createState() => _EmergencyAcceptState();
}

class _EmergencyAcceptState extends State<EmergencyAccept> {
  var user = FirebaseAuth.instance.currentUser;

  attList() {
    Timer(Duration(seconds: 5), () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    attList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Dentistas aceitos"),
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
                  .where("uidSocorrista", isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                    if (dataSnapshot.docs.length < 1) {
                      return const Text("Esperando Dentistas aceitarem...");
                    }
                    Map<String, dynamic> userMap =
                        dataSnapshot.docs[0].data() as Map<String, dynamic>;

                    return ListTile(
                        title: Text(
                            userMap.values.elementAt(5).toString() as String));
                  } else if (snapshot.hasError) {
                    return const Text("Algum erro aconteceu!");
                  } else {
                    return const Text("Nenhuma informação encontrada.");
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
