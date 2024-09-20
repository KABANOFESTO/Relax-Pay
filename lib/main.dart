import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/reset_passord_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/details_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relax-pay-App',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/reset_password': (context) => ResetPasswordScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/buying': (context) => BuyingScreen(),
        '/selling': (context) => SellingScreen(),
        // '/transaction': (context) => TransactionScreen(),
        '/stock': (context) => StocksListScreen(),
        // Add other routes here
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
