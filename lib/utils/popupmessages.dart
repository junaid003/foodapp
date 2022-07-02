import 'package:flutter/material.dart';

class PopUpmesaage {
  static alert(context, title, message, action) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textScaleFactor: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Text(
                        message,
                        textScaleFactor: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:const EdgeInsets.all(1),
                            child: SizedBox(
                              child: Container(
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    action();
                                  },
                                  child: const Center(
                                    child: SizedBox(
                                      width: 80,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: Center(
                                          child: Text(
                                            'OK',
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
