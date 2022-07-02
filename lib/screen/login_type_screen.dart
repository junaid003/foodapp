import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodapp/screen/home_screen.dart';
import 'package:foodapp/screen/phone_sigin_sncreen.dart';
import 'package:foodapp/utils/globals.dart';
import 'package:foodapp/utils/popupmessages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class sigintypescreen extends StatefulWidget {
  const sigintypescreen({Key? key}) : super(key: key);
  static String routeName = '/logintype_screen';

  @override
  State<sigintypescreen> createState() => _sigintypescreenState();
}

class _sigintypescreenState extends State<sigintypescreen> {
  bool isloadiing = false;
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
      setState(() {
        isloadiing = false;
      });
      print(e);
      PopUpmesaage.alert(context, "Warning", "Something Went Wrong", () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            child: InkWell(
              onTap: () async {
                setState(() {
                  isloadiing = true;
                });
                FirebaseAuth auth = FirebaseAuth.instance;
                User? user;

                final GoogleSignIn googleSignIn = GoogleSignIn();

                final GoogleSignInAccount? googleSignInAccount =
                    await googleSignIn.signIn();

                if (googleSignInAccount != null) {
                  final GoogleSignInAuthentication googleSignInAuthentication =
                      await googleSignInAccount.authentication;

                  final AuthCredential credential =
                      GoogleAuthProvider.credential(
                    accessToken: googleSignInAuthentication.accessToken,
                    idToken: googleSignInAuthentication.idToken,
                  );

                  try {
                    final UserCredential userCredential =
                        await auth.signInWithCredential(credential);

                    var userdata = auth.currentUser;
                    final userId = userdata!.uid;
                    Globals.userId = userId;
                    if (userdata.providerData[0].providerId == 'phone') {
                      Globals.username = userdata.phoneNumber.toString();
                    } else {
                      Globals.username = userdata.email.toString();
                    }
                    user = userCredential.user;
                    getCategory();
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      isloadiing = false;
                    });
                    PopUpmesaage.alert(
                        context, "Warning", "Something Went Wrong", () {
                      Navigator.pop(context);
                    });
                  } catch (e) {
                    setState(() {
                      isloadiing = false;
                    });
                    PopUpmesaage.alert(
                        context, "Warning", "Something Went Wrong", () {
                      Navigator.pop(context);
                    });
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: isloadiing
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 40,
                                  height: 35,
                                  color: Colors.blue[200],
                                  child: Image.asset(
                                    "assets/images/google.png",
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 205,
                            child: const Center(
                              child: Text(
                                "Google",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(phoneSigninScreen.routeName);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 90,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 220,
                      child: const Center(
                        child: Text(
                          "Phone",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
