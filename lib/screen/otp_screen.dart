import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodapp/screen/home_screen.dart';
import 'package:foodapp/utils/globals.dart';
import 'package:foodapp/utils/popupmessages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  static String routeName = '/otp_screen';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _pinEditingController = TextEditingController();
  String? mobileNumber = '';
  bool isCodeSent = false;
  String _verificationId = '';
  String smscode = '';
  var i = 0;
  String user = '';
  late String otp;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FocusScope.of(context).unfocus();
    FocusScope.of(context).dispose();
    super.dispose();
  }

  getCategory() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      var userdata = auth.currentUser;
      final userId = userdata!.uid;
      Globals.userId = userId;
      if (userdata.providerData[0].providerId == 'phone') {
        Globals.username = userdata.phoneNumber.toString();
      } else {
        Globals.username = userdata.email.toString();
      }

      Globals.categories = [];
      Globals.categorieDishes = [];
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

  Widget _buildOtp() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 0),
      child: Center(
        child: PinCodeTextField(
          appContext: context,
          pastedTextStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          length: 6,
          cursorHeight: 20,
          showCursor: false,
          autoFocus: true,
          hintCharacter: '\u2015',
          errorTextSpace: 25,
          autoDismissKeyboard: true,
          enablePinAutofill: false,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          blinkWhenObscuring: true,
          onSaved: (value) => otp = value!,
          animationType: AnimationType.fade,
          validator: (input) {
            if (input!.length < 6) {
              return " ";
            } else
              return null;
          },
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 30,
              fieldWidth: 20,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              selectedColor: Colors.transparent),
          cursorColor: Colors.grey,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: false,
          keyboardType: TextInputType.phone,
          onCompleted: (v) {},
          onChanged: (value) {
            otp = value;
          },
          beforeTextPaste: (text) {
            return true;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    mobileNumber = routeArgs['mobile_number'];

    if (i == 0) {
      _onVerifyCode();
      i++;
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Stack(children: [
            Positioned(
                top: 30,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 25,
                        ))
                  ],
                )),
            Positioned(
              top: 70,
              left: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .87,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 11),
                            child: Text(
                              "OTP has sent to $mobileNumber",
                              textScaleFactor: 1,
                              style: const TextStyle(
                                letterSpacing: 0.25,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                width: MediaQuery.of(context).size.width - 40,
                                height: 53,
                                child: Center(child: _buildOtp())),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Positioned(
              bottom: 17,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (!isloading) {
                          final formState = _formKey.currentState;
                          formState!.save();
                          if (formState.validate()) {
                            try {
                              setState(() {
                                isloading = true;
                              });
                              _onFormSubmitted();
                            } catch (e) {
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        }
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: 48.0,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Center(
                            child: isloading
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 25,
                                  )
                                : const Text(
                                    'CONTINUE',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      letterSpacing: 1.25,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _onVerifyCode() async {
    if (1 == 1) {
      setState(() {
        isCodeSent = true;
      });
      FocusScope.of(context).unfocus();
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _firebaseAuth
            .signInWithCredential(phoneAuthCredential)
            .then((dynamic value) async {
          getCategory();
        }).catchError((error) {
          print(error);
          setState(() {
            isloading = false;
          });
          var msg = error.toString();

          if (msg.contains('invalid-verification-code')) {
            PopUpmesaage.alert(
                context, "Sorry", 'Invalid OTP, Please enter a valid OTP', () {
              Navigator.pop(context);
            });
          } else if (msg.contains('session-expired')) {
            PopUpmesaage.alert(context, "Sorry",
                'The sms code has expired. Click resend to get another code',
                () {
              Navigator.pop(context);
            });
          } else {
            PopUpmesaage.alert(
                context, "Sorry", 'Something went wrong, Try again', () {
              Navigator.pop(context);
            });
          }
        });
      };
      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
        if (authException.message
            .toString()
            .contains('The format of the phone')) {
          PopUpmesaage.alert(context, "Sorry", 'Check the number and try again',
              () {
            Navigator.pop(context);
          });
        } else {
          PopUpmesaage.alert(
              context, "Sorry", 'Something went wrong, Try again', () {
            Navigator.pop(context);
          });
        }

        setState(() {
          isCodeSent = false;
        });
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int? forceResendingToken]) async {
        _verificationId = verificationId;
        setState(() {
          _verificationId = verificationId;
        });
      };
      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
        setState(() {
          _verificationId = verificationId;
        });
      };

      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91${this.mobileNumber}",
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } else {}
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) async {
      getCategory();
    }).catchError((error) {
      print(error);
      setState(() {
        isloading = false;
      });
      var msg = error.toString();

      if (msg.contains('invalid-verification-code')) {
        PopUpmesaage.alert(
            context, "Sorry", 'Invalid OTP, Please enter a valid OTP', () {
          Navigator.pop(context);
        });
      } else if (msg.contains('session-expired')) {
        PopUpmesaage.alert(context, "Sorry",
            'The sms code has expired. Click resend to get another code', () {
          Navigator.pop(context);
        });
      } else {
        PopUpmesaage.alert(context, "Sorry", 'Something went wrong, Try again',
            () {
          Navigator.pop(context);
        });
      }
    });
  }
}
