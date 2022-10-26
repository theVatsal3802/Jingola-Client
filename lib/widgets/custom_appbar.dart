import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final User? user = FirebaseAuth.instance.currentUser;
  late Future<String> name;

  Future<String> getName() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    return "Welcome, ${doc["name"]}";
  }

  @override
  void initState() {
    super.initState();
    name = getName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: name,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            title: Text(
              "Welcome",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
            ),
          );
        }
        return AppBar(
          title: Text(
            snapshot.data!,
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.white,
                ),
          ),
        );
      },
    );
  }
}
