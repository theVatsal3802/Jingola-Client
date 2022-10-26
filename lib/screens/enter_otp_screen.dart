import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './home_screen.dart';
import './new_user_screen.dart';

class EnterOTPScreen extends StatefulWidget {
  static const rouetName = "enter-otp";
  final String phoneNumber;
  const EnterOTPScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EnterOTPScreen> createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String code = "";
  final codeController = TextEditingController();

  Future<void> _checkNewUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          final name = value.get("name");
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName,
            arguments: name,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            NewUserScreen.routeName,
            (route) => false,
          );
        }
      },
    );
  }

  Future<void> _verfyPhone() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential).then(
            (value) async {
              if (value.user != null) {
                await _checkNewUser();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Something went wrong. Please try again.",
                      textScaleFactor: 1,
                    ),
                  ),
                );
              }
            },
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Something went wrong! Please try again",
                textScaleFactor: 1,
              ),
            ),
          );
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          setState(() {
            code = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            code = verificationId;
          });
        },
        timeout: const Duration(
          seconds: 60,
        ),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verfyPhone();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  "assets/images/name.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "We have sent an OTP to the given Phone number.",
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Enter OTP",
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        key: const ValueKey("otp"),
                        controller: codeController,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0.5,
                              color: Colors.black54,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "XXXXXX",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter OTP";
                          } else if (value.length != 6) {
                            return "Please enter a valid OTP";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        maxLength: 6,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator.adaptive()
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = !isLoading;
                                  });
                                  FocusScope.of(context).unfocus();
                                  bool valid =
                                      _formKey.currentState!.validate();
                                  if (!valid) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                        verificationId: code,
                                        smsCode: codeController.text.trim(),
                                      ),
                                    )
                                        .then(
                                      (value) async {
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        if (value.user != null) {
                                          await _checkNewUser();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Something went wrong. Please try again.",
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  } catch (e) {
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Invalid OTP! Please enter a valid OTP",
                                          textScaleFactor: 1,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Verify OTP",
                                  textScaleFactor: 1,
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Change Phone Number",
                            textScaleFactor: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
