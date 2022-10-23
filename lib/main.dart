import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/basket_screen.dart';
import './screens/category_item_screen.dart';
import './screens/checkout_screen.dart';
import './screens/home_screen.dart';
import './screens/orders_screen.dart';
import './screens/splash_screen.dart';
import './screens/voucher_screen.dart';
import './screens/auth_screen.dart';
import './screens/new_user_screen.dart';
import './config/theme.dart';
import './screens/contact_us_screen.dart';
import './screens/my_account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jingola',
      theme: theme(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        SplashScreen.routeName: (context) => const SplashScreen(),
        BasketScreen.routeName: (context) => BasketScreen(),
        CategoryItemScreen.routeName: (context) => const CategoryItemScreen(),
        CheckoutScreen.routeName: (context) => const CheckoutScreen(),
        OrdersScreen.routeName: (context) => const OrdersScreen(),
        NewUserScreen.routeName: (context) => const NewUserScreen(),
        VoucherScreen.routeName: (context) => const VoucherScreen(),
        MyAccountScreen.routeName: (context) => const MyAccountScreen(),
        ContactUsScreen.routeName: (context) => const ContactUsScreen(),
      },
    );
  }
}
