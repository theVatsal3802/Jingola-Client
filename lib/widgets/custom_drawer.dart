import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/my_account_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/basket_screen.dart';
import '../screens/terms_and_conditions_screen.dart';
import '../screens/contact_us_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          const SizedBox(
            height: 56,
          ),
          Center(
            child: Text(
              "JINGOLA INDIA",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
            leading: const Icon(Icons.home),
            title: Text(
              "Home",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MyAccountScreen.routeName);
            },
            leading: const Icon(Icons.account_circle),
            title: Text(
              "My Account",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
            leading: const Icon(Icons.shopping_bag),
            title: Text(
              "My Orders",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                BasketScreen.routeName,
                arguments: false,
              );
            },
            leading: const Icon(Icons.shopping_cart),
            title: Text(
              "My Basket",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ContactUsScreen.routeName);
            },
            leading: const Icon(Icons.contact_support),
            title: Text(
              "Contact Us",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TermsScreen.routeName);
            },
            leading: const Icon(Icons.rule),
            title: Text(
              "Terms and Conditions",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const Spacer(),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut().then(
                (_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName,
                    (route) => false,
                  );
                },
              );
            },
            leading: const Icon(Icons.logout),
            title: Text(
              "Logout",
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
