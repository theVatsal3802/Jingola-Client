import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  static const routeName = "/terms";
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("terms")
              .doc("tnc")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    snapshot.data!.data()!.values.toList()[index],
                    textScaleFactor: 1,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.start,
                  ),
                );
              },
              itemCount: snapshot.data!.data()!.length,
            );
          },
        ),
      ),
    );
  }
}
