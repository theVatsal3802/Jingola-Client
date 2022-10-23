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
  String name = "";

  Future<void> getName() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      name = "Welcome, ${doc["name"]}";
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        name,
        textScaleFactor: 1,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
