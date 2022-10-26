import 'package:flutter/material.dart';

import '../functions/other_functions.dart';

class VoucherScreen extends StatefulWidget {
  static const routeName = "/vouchers";
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    final bool applying = ModalRoute.of(context)!.settings.arguments as bool;
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
      body: FutureBuilder(
        future: OtherFunctions.getVouchers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text(
                    "No Vouchers Available",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
              : ListView.builder(
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
                          snapshot.data![index]["code"],
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                          snapshot.data![index]["description"],
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        trailing: applying
                            ? TextButton(
                                onPressed: () async {
                                  await OtherFunctions.applyVoucher(
                                    snapshot.data![index]["id"],
                                    snapshot.data![index],
                                  ).then(
                                    (value) {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                child: const Text(
                                  "APPLY",
                                  textScaleFactor: 1,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
        },
      ),
    );
  }
}
