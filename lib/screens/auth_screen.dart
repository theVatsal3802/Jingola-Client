import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './enter_otp_screen.dart';
import './home_screen.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";
  AuthScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return user != null
        ? const HomeScreen()
        : Scaffold(
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
                            TextFormField(
                              key: const ValueKey("mobile"),
                              autocorrect: true,
                              controller: phoneController,
                              enableSuggestions: true,
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
                                prefixIcon: const Icon(
                                  Icons.call,
                                ),
                                labelText: "Phone number",
                                prefixText: "+91",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter phone number";
                                } else if (value.trim().length != 10) {
                                  return "Phone number must be exactly 10 digits";
                                }
                                return null;
                              },
                              maxLength: 10,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EnterOTPScreen(
                                        phoneNumber:
                                            "+91${phoneController.text.trim()}",
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Continue",
                                textScaleFactor: 1,
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
