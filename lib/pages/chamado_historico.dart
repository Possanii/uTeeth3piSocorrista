import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/historico_details.dart';

class ChamadoHistorico extends StatefulWidget {
  const ChamadoHistorico({Key? key}) : super(key: key);

  @override
  State<ChamadoHistorico> createState() => _ChamadoHistoricoState();
}

class _ChamadoHistoricoState extends State<ChamadoHistorico> {
  var user = FirebaseAuth.instance.currentUser;
  var uid = [];
  var uidDentista = [];
  var rate = [];
  var date = [];
  var comentario = [];
  bool buscouInfo = true;
  var nome = [];
  var telefone = [];
  var address = [];

  void getAllInfoDentista() async {
    if (buscouInfo == true) {
      buscouInfo = false;
      try {
        CollectionReference chamado =
            FirebaseFirestore.instance.collection('Chamados');

        for (var i = 0; i < uid.length; i++) {
          await chamado.doc(uid[i]).collection('rate').get().then((value) => {
                rate.add(value.docs[0].data()['nota']),
                date.add(value.docs[0].get('data')),
                comentario.add(value.docs[0].data()['comentário'])
              });
        }

        CollectionReference dentista =
            FirebaseFirestore.instance.collection('dentista');

        for (var i = 0; i < uidDentista.length; i++) {
          dentista.doc(uidDentista[i]).get().then((value) => {
                setState(() {
                  nome.add(value.get('name'));
                  telefone.add(value.get('phone'));
                  address.add(value.get('address1'));
                }),
              });
        }
      } on FirebaseException catch (e) {
        const snackBar = SnackBar(content: Text("Erro ao criar chamado"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        throw Exception("erro ao criar chamado: ${e}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Historico de atendimentos",
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
        child: Column(children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Chamados")
                  .where('uidSocorrista', isEqualTo: user?.uid)
                  .where("status", isEqualTo: "Close")
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
                            uidDentista = [];
                            snapshot.data?.docs.forEach((doc) {
                              uid.contains(doc.data()['uid'])
                                  ? null
                                  : uid.add(doc.data()['uid']);
                              uidDentista.add(doc.data()['uidDentista']);
                            });
                            getAllInfoDentista();
                            if (nome.isEmpty)
                              return const CircularProgressIndicator();
                            else {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                      nome[index].toString().toUpperCase()),
                                  subtitle: Text(
                                      address[index].toString().toUpperCase()),
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailsHistorico(
                                            rate: rate[index],
                                            comentario: comentario[index],
                                            date: date[index],
                                            address: address[index],
                                            nome: nome[index],
                                            telefone: telefone[index],
                                          ),
                                        )),
                                  },
                                  dense: true,
                                ),
                              );
                            }
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
                          Text("Nenhum historico."),
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
