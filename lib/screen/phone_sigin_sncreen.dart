import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_screen.dart';

class phoneSigninScreen extends StatefulWidget {
  static String routeName = '/signin_screen';

  @override
  _phoneSigninScreenState createState() => _phoneSigninScreenState();
}

class _phoneSigninScreenState extends State<phoneSigninScreen> {
  String mobileNumber = '';
  TextEditingController mobileNumbercontroller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSingin = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusScope.of(context).dispose();
    mobileNumbercontroller.dispose();
    super.dispose();
  }

  Widget _buildphoneInputFeild() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.lightBlue[50]),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1,
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: mobileNumbercontroller,
          maxLength: 10,
          validator: (input) {
            if (input!.isEmpty) {
              return "Please enter valid mobile number";
            } else if (input.length < 10) {
              return "Please enter valid mobile number";
            } else if (input.trim().startsWith('0')) {
              return "Enter valid phone number";
            } else
              return null;
          },
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 3,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (value) {
            if (value.length == 10) {
              FocusScope.of(context).unfocus();
            }
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Enter 10 digit phone number',
            suffixText: '${mobileNumbercontroller.text.length.toString()}/10',
            suffixStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
            counterText: "",
            contentPadding: const EdgeInsets.only(top: 15, bottom: 10, right: 10),
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: .4,
              color: Colors.black,
            ),
            isDense: false,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(top: 15, left: 14, right: 5),
              child: Text(
                '91  │',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.25,
                ),
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _buildContinuBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).pushNamed(OtpScreen.routeName, arguments: {
              'mobile_number': mobileNumbercontroller.value.text,
            });
          }
        },
        child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Text(
                'CONTINUE',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.25,
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildphoneInputFeild(),
              const SizedBox(height: 10),
              _buildContinuBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
