import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/location_page.dart';

class LoadingWaitingLocation extends StatefulWidget {
  var id;

  LoadingWaitingLocation({Key? key, required this.id}) : super(key: key);

  @override
  State<LoadingWaitingLocation> createState() => _LoadingWaitingLocationState();
}

class _LoadingWaitingLocationState extends State<LoadingWaitingLocation> {
  goToAccept(id) {
    Timer(
        Duration(seconds: 5),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => LocationPage(id: id))));
  }

  @override
  Widget build(BuildContext context) {
    goToAccept(widget.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromRGBO(
                  4, 9, 87, 1), // Cor do indicador de carregamento
            ),
            SizedBox(height: 20),
            Text(
              'Aguardando localização...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
