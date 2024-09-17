import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/db_heleper.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var existingUser = await _dbHelper.findUserByEmail(email);

    if (existingUser == null) {
      await _dbHelper.insertUser({'email': email, 'password': password});
      Fluttertoast.showToast(msg: "Signup successful");
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Fluttertoast.showToast(msg: "User with this email already exists");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
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
              onPressed: _signup,
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
