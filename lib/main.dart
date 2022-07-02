import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/provider/cart_provider.dart';
import 'package:foodapp/screen/cart_screen.dart';
import 'package:foodapp/screen/home_screen.dart';
import 'package:foodapp/screen/login_type_screen.dart';
import 'package:foodapp/screen/phone_sigin_sncreen.dart';
import 'package:foodapp/screen/otp_screen.dart';
import 'package:foodapp/screen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const sigintypescreen(),
          home: SplashScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            OtpScreen.routeName: (ctx) => OtpScreen(),
            phoneSigninScreen.routeName: (ctx) => phoneSigninScreen(),
            Cartscreen.routeName: (ctx) => Cartscreen(),
            sigintypescreen.routeName: (ctx) => sigintypescreen(),
          }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
