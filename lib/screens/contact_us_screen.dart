import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class ContactUsScreen extends StatelessWidget {
  static const routeName = "/contact-us";
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Contact Us",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We are here to help you with any issues you face while using our app.",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Email your queries at:",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "jingolaofficial@gmail.com",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "OR",
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "jingolaconnect@gmail.com",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/name.png",
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
