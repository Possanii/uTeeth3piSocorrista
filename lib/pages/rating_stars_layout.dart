import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/menu.dart';

class RatingStars extends StatefulWidget {
  var id;

  RatingStars({Key? key, required this.id}) : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  int rating = 0;
  String comment = '';

  Future<void> sendRatingToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection("Chamados")
          .doc(widget.id)
          .update({"status": "Close"});
      await FirebaseFirestore.instance
          .collection("Chamados")
          .doc(widget.id)
          .collection('rate')
          .add({"nota": rating, "comentário": comment, "data": DateTime.now()});
      const snackBar = SnackBar(content: Text("Avaliação concluida."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text("Erro ao criar chamado"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("erro ao criar chamado: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  rating = 1;
                });
              },
              icon: Icon(
                rating >= 1 ? Icons.star : Icons.star_border,
                size: 40,
              ),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  rating = 2;
                });
              },
              icon: Icon(
                rating >= 2 ? Icons.star : Icons.star_border,
                size: 40,
              ),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  rating = 3;
                });
              },
              icon: Icon(
                rating >= 3 ? Icons.star : Icons.star_border,
                size: 40,
              ),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  rating = 4;
                });
              },
              icon: Icon(
                rating >= 4 ? Icons.star : Icons.star_border,
                size: 40,
              ),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  rating = 5;
                });
              },
              icon: Icon(
                rating >= 5 ? Icons.star : Icons.star_border,
                size: 40,
              ),
              color: Colors.orange,
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (value) {
              setState(() {
                comment = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Comentário (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await sendRatingToFirestore();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Menu()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(4, 9, 87, 1),
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
