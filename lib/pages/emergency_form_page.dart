import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:uno/uno.dart';
import 'package:uteeth_socorrista/pages/loading_page.dart';




class EmergencyFormPage extends StatefulWidget {
  File arquivo;

  EmergencyFormPage({Key? key, required this.arquivo}) : super (key: key);

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



  Future<void> sendFileToFirestore() async {

    try {
        final userCredential =
        await FirebaseAuth.instance.signInAnonymously();
        final fcmToken = await FirebaseMessaging.instance.getToken();


        // FirebaseFunctions functions = FirebaseFunctions.instance;

      CollectionReference chamado = FirebaseFirestore.instance.collection('Chamados');

      await chamado.add({
        'uidSocorrista': userCredential.user?.uid,
        'nome': name,
        'telefone': phone,
        'fcmTokenSocorrista': fcmToken,
        'status': 'open',
      }).then((value) async {
        upload(value.id);
        uno.post("https://southamerica-east1-uteeth-3pi-puc.cloudfunctions.net/onEmergencyCreated", data: {"data": value.id});
        // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('onEmergencyCreated');
        // final cResponse = await callable.call(
        // {"data": value.id});
        const snackBar = SnackBar(
            content: Text("Chamado criado."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(
          content: Text("Erro ao criar chamado"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("erro ao criar chamado: ${e}");
    }
  }

  Future<void> upload(String id) async {
    try {
      String ref = "${id}/${id}_${DateTime.now().toString()}.jpg";
      await storage.ref(ref).putFile(widget.arquivo);
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
                      decoration: const InputDecoration(
                          labelText: 'Nome'
                      ),
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
                      decoration: const InputDecoration(
                        labelText: 'Telefone'
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendFileToFirestore();
                          setState(() {
                            name = nameController.text;
                            phone = telefoneController.text;
                          });
                          telefoneController.text = "";
                          nameController.text = "";
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chamado Criado!')),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingPage()),);
                        }
                      },
                      child: const Text('Submit'),
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

