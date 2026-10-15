import 'package:flutter/material.dart';
import 'package:klinik_app/helpers/user_info.dart';
import 'package:klinik_app/ui/beranda.dart';
import 'ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var token = await UserInfo().getToken();
  print(token);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Klinik APP',
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF77216F), // Aubergine
        foregroundColor: Colors.white,
      ),
    ),
    home: token == null ? Login() : Beranda(),
  ));
}