import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MyLanguaguageView extends StatefulWidget {
  const MyLanguaguageView({Key? key}) : super(key: key);

  @override
  State<MyLanguaguageView> createState() => _MyLanguaguageViewState();
}

class _MyLanguaguageViewState extends State<MyLanguaguageView> {
  //variable
  TextEditingController controller = TextEditingController();
  String texte = "";
  LanguageIdentifier languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.7);
  Uint8List? bytesImage;
  late InputImage image;
  ImageLabeler labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
  String resultatString ="";




 pickImage() async {
   FilePickerResult? resultat = await FilePicker.platform.pickFiles(
       type: FileType.image,
       withData: true
   );
   if(resultat != null){
     setState(() {
       bytesImage = resultat.files.first.bytes;
       image = InputImage.fromFilePath(resultat.files.first.path!);

     });

   }
 }


 processing() async{
   resultatString ="";
   final labels = await labeler.processImage(image);
   print(labels.length);
   for(var  l in labels){
     setState(() {
       resultatString += "\n${l.label} avec une confiance de ${(l.confidence *100).toInt()} %";
     });

   }


 }

  simpleIndentification() async {


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: bodyPage(),
    );
  }

  Widget bodyPage(){
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Entrer un texte",

            ),
          ),
          ElevatedButton(onPressed:simpleIndentification,
              child: const Text("Identification")
          ),
          Text(texte),

          ElevatedButton(
              onPressed: pickImage,
              child: const Text("Image")
          ),

          (bytesImage != null)?Image.memory(bytesImage!,height: 350,):Container(),
          ElevatedButton(
              onPressed: processing,
              child: const Text("Determination")
          ),
          Text(resultatString)
        ],
      ),
    );
  }
}
