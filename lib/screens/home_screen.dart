import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../functions/other_functions.dart';
import '../widgets/category_box.dart';
import '../widgets/promo_box.dart';
import '../models/voucher_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("vouchers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return PromoBox(
                          voucher: Voucher.fromSnapshot(
                            snapshot.data!.docs[index],
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                ),
              ),
              Text(
                "What would you like to have?",
                textScaleFactor: 1,
                softWrap: true,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: OtherFunctions.getCategories(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return CategoryBox(
                        category: snapshot.data[index],
                      );
                    },
                    itemCount: snapshot.data.length,
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
