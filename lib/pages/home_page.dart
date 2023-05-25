import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uteeth_socorrista/pages/emergency_form_page.dart';
import 'package:uteeth_socorrista/pages/preview_page.dart';
import 'package:uteeth_socorrista/widgets/anexo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? arquivo;

  showPreview(file) async {
    File? arq = await Get.to(() => PreviewPage(file: file));

    if (arq != null) {
      setState(() => arquivo = arq);
      Get.back();
    }
  }

  emergencyForm(File arquivo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmergencyFormPage(arquivo: arquivo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (arquivo != null) Anexo(arquivo: arquivo!),
                ElevatedButton.icon(
                  onPressed: () => Get.to(
                    () => CameraCamera(onFile: (file) => showPreview(file)),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tire uma foto'),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      textStyle: const TextStyle(
                        fontSize: 18,
                      )),
                ),
                const Padding(padding: EdgeInsets.only(top: 48)),
                OutlinedButton.icon(
                    onPressed: () {
                      if (arquivo != null) {
                        emergencyForm(arquivo!);
                      } else {
                        const snackBar = SnackBar(
                            content: Text('Nenhum arquivo selecionado'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: const Icon(Icons.send_and_archive),
                    label: const Text("Enviar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
