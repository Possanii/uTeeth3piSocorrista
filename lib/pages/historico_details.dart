import 'package:flutter/material.dart';

class DetailsHistorico extends StatefulWidget {
  var rate;
  var date;
  var comentario;
  var nome;
  var telefone;
  var address;

  DetailsHistorico(
      {Key? key,
      required this.rate,
      required this.date,
      required this.comentario,
      required this.nome,
      required this.address,
      required this.telefone})
      : super(key: key);

  @override
  State<DetailsHistorico> createState() => _DetailsHistoricoState();
}

class _DetailsHistoricoState extends State<DetailsHistorico> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detalhes',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalhes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(4, 9, 87, 1),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dentista:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.nome,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Telefone:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.telefone,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Endereço:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.address,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text(
                    'Avaliação:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 18,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    widget.rate.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Comentário:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.comentario,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
