import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/auth/auth_gate.dart';
import 'package:recipe/state/controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  Get.put(MyController());

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    anonKey: dotenv.env['SUPABASE_KEY'] as String,
    url: dotenv.env['SUPABASE_URL'] as String,
  );

  runApp(
    const GetMaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
