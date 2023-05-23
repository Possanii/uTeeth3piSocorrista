import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

// Exemplo de uso da página de carregamento
void main() {
  runApp(MaterialApp(
    home: LoadingPage(),
  ));
}