import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void pickFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;
    setState(() {
      file = File(pickedFile.path);
    });
    debugPrint(file!.path);

  }
  String? imagePath;
  String? finalText;
  String? blockk;
  String? textt;
  String? wordss;
  File? file;
  final textDetector = GoogleMlKit.vision.textRecognizer();
  void pickFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return;
    setState(() {
      file = File(pickedFile.path);
    });
    debugPrint(file!.path);
  }
  getImageTxt()async{
    final inputImg = InputImage.fromFile(file!);
    final RecognizedText recognizedText = await textDetector.processImage(inputImg);
    setState(() {
      textt= recognizedText.text;
    });
    print("--- "+textt.toString());
    for(TextBlock block in recognizedText.blocks){
      setState(() {
        blockk = blockk! + '------ ' + recognizedText.text;
      });
      for (TextLine line in block.lines){
        setState(() {
          wordss = wordss! + '------ ---- ' + recognizedText.text;
        });
        for(TextElement element in line.elements){
          setState(() {
            finalText = finalText! + '------ ----*-*-*-* ' + element.text;
          });
          print(finalText);
        }
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: (){pickFromCamera();},
                    child: Text("cam")),
                // ElevatedButton(
                //     onPressed: (){pickFromGallery();},
                //     child: Text("Gallery")),
                ElevatedButton(
                    onPressed: (){getImageTxt();},
                    child: Text("extract")),
                if(file!=null)
                Image.file(file!),
                if(textt!=null)
                Text(textt.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
