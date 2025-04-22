import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'dart:developer' as dev;
import 'package:stoneindia/contants.dart';

class Otpscreen extends StatefulWidget {
  final String mobile;
  final Function? onVerificationDone;
  final String verificationId;

  const Otpscreen({
    super.key,
    required this.mobile,
    this.onVerificationDone,
    required this.verificationId,
  });

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  bool isLoading = false;
  TextEditingController otpController = TextEditingController();
  String? newVerificationId;

  FirebaseAuth auth = FirebaseAuth.instance;

  int seconds = 30;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  void resendOtp() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.mobile,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then(
          (value) {
            if (value.user != null) {
              widget.onVerificationDone!();
            }
          },
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          newVerificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // // resend otp
  // Future<void> resendOTP() async {
  //   await auth.verifyPhoneNumber(
  //     phoneNumber: widget.mobile,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(e.message!),
  //       ));
  //     },
  //     codeSent: (String verificationId, int? resendToken) {},
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }

  String resendOtpText() {
    if (seconds == 0) {
      return 'Resend OTP';
    }
    // progressive countdown
    String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsText = (seconds % 60).toString().padLeft(2, '0');
    return 'Resend OTP in $minutes:$secondsText';
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter OTP"),
      ));
      return;
    }
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: newVerificationId ?? widget.verificationId,
          smsCode: otpController.text);

      await auth.signInWithCredential(credential).then(
        (value) {
          if (value.user != null) {
            widget.onVerificationDone!();
          }
        },
      );
    }
    // catch firebase exceptions
    catch (e) {
      dev.log(e.toString());
      if (e.toString().contains("invalid-verification-code")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid OTP"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    dev.log(FirebaseAuth.instance.currentUser!.uid);
    // auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Enter OTP sent to your mobile number',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.mobile,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Pinput(
                  controller: otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  // shapeBorder: RoundedRectangleBorder(
                  //   borderRadius: radius(),
                  // ),

                  onPressed: () {
                    verifyOTP();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 28,
                          child: FittedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 6,
                              color: textPrimaryWhiteColor,
                            ),
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 18,
                            color: textPrimaryWhiteColor,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextButton(
                  onPressed: () {
                    // resendOTP();

                    if (seconds != 0) {
                      return;
                    }
                    resendOtp();
                    // reset the timer
                    setState(() {
                      seconds = 30;
                    });
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                      if (seconds == 0) {
                        timer.cancel();
                      } else {
                        setState(() {
                          seconds--;
                        });
                      }
                    });
                  },
                  child: Text(
                    resendOtpText(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: seconds != 0 ? textSecondaryColor : kPrimaryColor,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                // resend otp button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
