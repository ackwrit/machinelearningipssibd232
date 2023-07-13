import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mlearning/controller/permissionPhoto.dart';
import 'package:mlearning/language_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyLanguaguageView(),
      debugShowCheckedModeBanner: false,
    );
  }
}


