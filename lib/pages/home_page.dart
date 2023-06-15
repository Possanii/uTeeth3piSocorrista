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
  List<File> arquivo = [];

  showPreview(file) async {
    File? arq = await Get.to(() => PreviewPage(file: file));

    if (arq != null) {
      setState(() => arquivo.add(arq));
      Get.back();
    }
  }

  emergencyForm(List<File> arquivo) {
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
                if (arquivo.isNotEmpty) Anexo(arquivo: arquivo[0]!),
                if (arquivo.isNotEmpty && arquivo.length >= 2)
                  Anexo(arquivo: arquivo[1]!),
                if (arquivo.isNotEmpty && arquivo.length >= 3)
                  Anexo(arquivo: arquivo[2]!),
                if (arquivo.length == 0)
                  ElevatedButton.icon(
                    onPressed: () => Get.to(
                      () => CameraCamera(onFile: (file) => showPreview(file)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Tire uma foto')),
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(4, 9, 87, 1),
                        )),
                  ),
                if (arquivo.length < 3 && arquivo.length >= 1)
                  ElevatedButton.icon(
                    onPressed: () => Get.to(
                      () => CameraCamera(onFile: (file) => showPreview(file)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Tire outra foto')),
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(4, 9, 87, 1),
                        )),
                  ),
                const Padding(padding: EdgeInsets.only(top: 48)),
                OutlinedButton.icon(
                    onPressed: () {
                      if (arquivo.length == 3) {
                        emergencyForm(arquivo!);
                      }
                      if (arquivo.length < 3 && arquivo.isNotEmpty) {
                        const snackBar =
                            SnackBar(content: Text('Tire 3 fotos'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (arquivo.isEmpty) {
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
