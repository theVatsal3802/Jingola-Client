import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Orders",
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
                "Your Today's Orders",
                textScaleFactor: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .where(
                      "userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .where(
                      "date",
                      isEqualTo:
                          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Text(
                            "No orders done today yet!",
                            textScaleFactor: 1,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return OrderTile(
                              order: snapshot.data!.docs[index].data(),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Your All Orders",
                textScaleFactor: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .where(
                      "userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Text(
                            "No past orders yet!",
                            textScaleFactor: 1,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return OrderTile(
                              order: snapshot.data!.docs[index].data(),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
