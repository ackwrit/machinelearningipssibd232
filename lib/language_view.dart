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
  LanguageIdentifier languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.1);
  OnDeviceTranslator translator = OnDeviceTranslator(sourceLanguage: TranslateLanguage.french, targetLanguage: TranslateLanguage.danish);

















  Uint8List? bytesImage;
  late InputImage image;
  late ObjectDetector detectedObject;
  ObjectDetectorOptions objectDetectorOptions = ObjectDetectorOptions(
      mode: DetectionMode.single,
      classifyObjects: true,
      multipleObjects: true
  );
  ImageLabeler labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.1));
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




 }

  simpleIndentification() async {
    texte = "";
    if(controller.text != null && controller.text != ""){
      String phrase = controller.text;

     String provisoire = await languageIdentifier.identifyLanguage(phrase);
     setState(() {
       texte = provisoire;
     });
    }
 }


  mutipleIndentification() async{
      texte = "";
     if(controller.text != null && controller.text != ""){
       String phrase = controller.text;
       List multiplePhrase = await languageIdentifier.identifyPossibleLanguages(phrase);
       for(IdentifiedLanguage label in multiplePhrase){
         setState(() {
           print(label.languageTag);
           texte += "\n${label.languageTag} avec une confiance de ${(label.confidence *100).toInt()} %";
         });

       }

     }
  }

  traduction() async{
   texte = "";
   if(controller.text != null && controller.text != ""){
      String phrase = controller.text;
      String provisoire =await translator.translateText(phrase);
      setState(() {
        texte = provisoire;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    detectedObject = ObjectDetector(options: objectDetectorOptions);

    super.initState();
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
          ///////////////////////
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Entrer un texte",

            ),
          ),
          ElevatedButton(
              onPressed:simpleIndentification,
              child: const Text("Identification")
          ),


          ElevatedButton(
              onPressed:mutipleIndentification,
              child: const Text("Multiple identification")
          ),

          ElevatedButton(
              onPressed:traduction,
              child: const Text("Traduire")
          ),


          Text(texte),
          ///////////////////






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
