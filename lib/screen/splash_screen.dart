import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodapp/screen/home_screen.dart';
import 'package:foodapp/screen/login_type_screen.dart';
import 'package:foodapp/screen/phone_sigin_sncreen.dart';
import 'package:foodapp/utils/globals.dart';
import 'package:foodapp/utils/popupmessages.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateTo();
  }

  navigateTo() {
    Future.delayed(const Duration(seconds: 3), () async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      var user = auth.currentUser;
      if (user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            sigintypescreen.routeName, (Route<dynamic> route) => false);
      } else {
        var userdata = auth.currentUser;
        final userId = userdata!.uid;
        Globals.userId = userId;
        if (userdata.providerData[0].providerId == 'phone') {
          Globals.username = userdata.phoneNumber.toString();
        } else {
          Globals.username = userdata.email.toString();
        }
        getCategory();
      }
    });
  }

  getCategory() async {
    try {
      var url = 'https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad';
      var response = await http.get(
        Uri.parse(url),
      );
      var bodydata = jsonDecode(response.body);
      bodydata.forEach((it) {
        it['table_menu_list'].forEach((element) {
          Globals.categories.add(element['menu_category']);
          Globals.categorieDishes.add(element['category_dishes']);
        });
      });

      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
    } catch (e) {
      print(e);
      PopUpmesaage.alert(context, "Warning", "Something Went Wrong", () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset("assets/images/2.jpg"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SpinKitThreeBounce(
            color: Colors.blue.shade200,
            size: 30,
          ),
        ),
      ]),
    );
  }
}
