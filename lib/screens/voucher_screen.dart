import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoucherScreen extends StatelessWidget {
  static const routeName = "/vouchers";
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Vouchers",
          textScaleFactor: 1,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("vouchers").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    snapshot.data!.docs[index].get("code"),
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    snapshot.data!.docs[index].get("description"),
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        snapshot.data!.docs[index].data(),
                      );
                    },
                    child: const Text(
                      "APPLY",
                      textScaleFactor: 1,
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
