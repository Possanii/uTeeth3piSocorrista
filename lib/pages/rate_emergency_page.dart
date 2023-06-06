import 'package:flutter/material.dart';
import 'package:uteeth_socorrista/pages/rating_stars_layout.dart';

class RateEmergencyPage extends StatefulWidget {
  var id;

  RateEmergencyPage({Key? key, required this.id}) : super(key: key);

  @override
  State<RateEmergencyPage> createState() => _RateEmergencyPageState();
}

class _RateEmergencyPageState extends State<RateEmergencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliação'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Deixe sua avaliação',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            RatingStars(id: widget.id),
          ],
        ),
      ),
    );
  }
}
