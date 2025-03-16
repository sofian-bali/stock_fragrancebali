import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env chargé avec succès !");
  } catch (e) {
    print("❌ Erreur lors du chargement de .env : $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Stock de Parfums")),
        body: const ProductsScreen(), // 👈 Charge l'écran avec recherche intégrée
      ),
    );
  }
}