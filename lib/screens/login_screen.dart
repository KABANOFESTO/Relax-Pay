import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/db_heleper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var user = await _dbHelper.getUser(email, password);

    if (user != null) {
      Fluttertoast.showToast(msg: "Login successful");
      // Navigate to the home screen or another page
    } else {
      Fluttertoast.showToast(msg: "Invalid email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text("Don't have an account? Sign up"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/reset_password'),
              child: Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}
