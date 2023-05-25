import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/emergency_accept.dart';

class LoadingPage extends StatefulWidget {
  var id;
  var name;

  LoadingPage({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  goToAccept() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    EmergencyAccept(id: widget.id, name: widget.name))));
  }

  @override
  Widget build(BuildContext context) {
    goToAccept();

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Indicador de carregamento circular
            SizedBox(height: 20), // Espaçamento entre o indicador e o texto
            Text(
              'Encontrando Dentistas...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
