import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';
import 'package:uteeth_socorrista/pages/loading_waiting_location.dart';

class EmergencyAccept extends StatefulWidget {
  var id;
  var name;

  EmergencyAccept({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<EmergencyAccept> createState() => _EmergencyAcceptState();
}

class _EmergencyAcceptState extends State<EmergencyAccept> {
  final uno = Uno();
  var user = FirebaseAuth.instance.currentUser;

  Future<void> EmergencyAcceptByUser(uid, fcmToken) async {
    try {
      CollectionReference chamado =
          FirebaseFirestore.instance.collection('Chamados');

      await chamado.doc(widget.id).update({
        'status': 'Accept',
        'socorristaAccept': true,
        'uidDentista': uid,
        'fcmTokenDentista': fcmToken,
      }).then((value) async {
        uno.post(
            "https://southamerica-east1-uteeth-3pi-puc.cloudfunctions.net/sendFcmMessage",
            data: {
              "data": {
                "fcmToken": fcmToken,
                "textContent": "${widget.name} aceitou seu chamado"
              }
            });
        const snackBar =
            SnackBar(content: Text("Solicitação enviada para o dentista."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text("Erro ao criar chamado"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("erro ao criar chamado: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione um dentista"),
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
                  .collection('dentista')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Container(
                        height: 600,
                        width: 400,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemExtent: 100,
                          itemBuilder: (context, index) {
                            var nomes = [];
                            var curriculum = [];
                            var uid = [];
                            var fcmToken = [];
                            snapshot.data?.docs.forEach((doc) {
                              nomes.add(doc.data()['name']);
                              curriculum.add(doc.data()['curriculum']);
                              uid.add(doc.data()['uid']);
                              fcmToken.add(doc.data()['fcmToken']);
                            });
                            return ListTile(
                              title: Text(nomes[index]),
                              subtitle: Text(curriculum[index]),
                              dense: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () =>
                                          {print('removeu ${nomes[index]}')},
                                      icon: Icon(Icons.cancel)),
                                  IconButton(
                                      onPressed: () async => {
                                            await EmergencyAcceptByUser(
                                                uid[index], fcmToken[index]),
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      LoadingWaitingLocation(
                                                          id: widget.id),
                                                )),
                                          },
                                      icon: Icon(Icons.check_box))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Algum erro aconteceu!");
                  } else {
                    return const Center(
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Aguardando dentista."),
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
