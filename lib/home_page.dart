import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:uteeth_socorrista/preview_page.dart';
import 'package:uteeth_socorrista/widgets/anexo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? arquivo;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future getFileFromGallery() async {
    PickedFile? file = await picker.getImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() => arquivo = File(file.path));
    }
  }

  showPreview(file) async {
    File? arq = await Get.to(() => PreviewPage(file: file));

    if (arq != null) {
      setState(() => arquivo = arq);
      Get.back();
    }
  }

  Future sendFileToFirestore(File? arquivo) async {

    try {
      String ref = "images/img-${DateTime.now().toString()}.jpg";
      await storage.ref(ref).putFile(arquivo!);
      const snackBar = SnackBar(
          content: Text('Arquivo enviado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseException catch (e) {
      throw Exception("erro no upload da imagem: ${e.code}");
    }
  }

  Future<void> upload(File arquivo) async {
    try {
      String ref = "images/img-${DateTime.now().toString()}.jpg";
      await storage.ref(ref).putFile(arquivo);
    } on FirebaseException catch (e) {
      throw Exception("erro no upload da imagem: ${e.code}");
    }
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
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('ou'),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Selecione um arquivo'),
                  onPressed: () => getFileFromGallery(),
                ),
                const Padding(padding: EdgeInsets.only(top: 48)),
                OutlinedButton.icon(
                    onPressed: () {
                      if (arquivo != null) {
                        sendFileToFirestore(arquivo);
                      } else {
                        const snackBar = SnackBar(
                            content: Text('Nenhum arquivo selecionado'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: const Icon(Icons.send_and_archive),
                    label: const Text("Enviar")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}