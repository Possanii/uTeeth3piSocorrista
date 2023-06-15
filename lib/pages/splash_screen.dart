import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goToHome() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Menu())));
  }

  @override
  Widget build(BuildContext context) {
    goToHome();

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(4, 9, 87, 1),
            image: DecorationImage(
              image: AssetImage('lib/images/logo_azul.png'),
              // Caminho da imagem da logo
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
