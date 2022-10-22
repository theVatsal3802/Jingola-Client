import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/other_functions.dart';
import './home_screen.dart';

class NewUserScreen extends StatefulWidget {
  static const routeName = "/new-user";
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final nameController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
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
                        key: const ValueKey("name"),
                        autocorrect: true,
                        controller: nameController,
                        enableSuggestions: true,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
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
                            Icons.person,
                          ),
                          labelText: "Name",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      if (!isLoading)
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            User? user = FirebaseAuth.instance.currentUser;
                            await OtherFunctions.saveUser(
                              name: nameController.text.trim(),
                              userId: user!.uid,
                              phoneNumer: user.phoneNumber!,
                            ).then((value) {
                              setState(() {
                                isLoading = !isLoading;
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                HomeScreen.routeName,
                                arguments: nameController.text.trim(),
                                (route) => false,
                              );
                            });
                          },
                          child: const Text(
                            "Save Name",
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
