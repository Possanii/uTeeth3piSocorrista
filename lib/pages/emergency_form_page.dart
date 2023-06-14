import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';
import 'package:uteeth_socorrista/pages/loading_page.dart';

class EmergencyFormPage extends StatefulWidget {
  List<File> arquivo;

  EmergencyFormPage({Key? key, required this.arquivo}) : super(key: key);

  @override
  _EmergencyFormPageState createState() => _EmergencyFormPageState();
}

class _EmergencyFormPageState extends State<EmergencyFormPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final uno = Uno();
  final nameController = TextEditingController();
  final telefoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String phone;
  late String id;
  late String path;
  late String path1;
  late String path2;

  Future<void> sendFileToFirestore() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      // FirebaseFunctions functions = FirebaseFunctions.instance;

      CollectionReference chamado =
          FirebaseFirestore.instance.collection('Chamados');

      await chamado.add({
        'uidSocorrista': userCredential.user?.uid,
        'name': name,
        'phone': phone,
        'fcmTokenSocorrista': fcmToken,
        'status': 'open',
        'socorristaAccept': false,
      }).then((value) async {
        id = value.id;
        await upload(value.id);
        chamado.doc(id).update({
          "uid": id,
          "photoPath": path,
          "photoPath1": path1,
          "photoPath2": path2
        });
        uno.post(
            "https://southamerica-east1-uteeth-3pi-puc.cloudfunctions.net/onEmergencyCreated",
            data: {"data": value.id});
        const snackBar = SnackBar(content: Text("Chamado criado."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text("Erro ao criar chamado"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("erro ao criar chamado: ${e}");
    }
  }

  Future<void> upload(String id) async {
    try {
      String ref = "${id}/${id}_${DateTime.now().toString()}_1.jpg";
      var photoStorage = await storage.ref(ref).putFile(widget.arquivo[0]);
      String ref1 = "${id}/${id}_${DateTime.now().toString()}_2.jpg";
      var photoStorage1 = await storage.ref(ref1).putFile(widget.arquivo[1]);
      String ref2 = "${id}/${id}_${DateTime.now().toString()}_3.jpg";
      var photoStorage2 = await storage.ref(ref2).putFile(widget.arquivo[2]);

      await photoStorage.ref.getDownloadURL().then((value) => path = value);
      await photoStorage1.ref.getDownloadURL().then((value) => path1 = value);
      await photoStorage2.ref.getDownloadURL().then((value) => path2 = value);
    } on FirebaseException catch (e) {
      throw Exception("erro no upload da imagem: ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Abrir Emergência'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu nome';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: telefoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu telefone';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Telefone'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              name = nameController.text;
                              phone = telefoneController.text;
                            });
                            await sendFileToFirestore();
                            telefoneController.text = "";
                            nameController.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chamado Criado!')),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoadingPage(
                                        id: id,
                                        name: name,
                                      )),
                            );
                          }
                        },
                        child: const Text('Criar chamado'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
