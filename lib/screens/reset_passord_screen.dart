import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/db_heleper.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _resetPassword() async {
    String email = _emailController.text;
    String newPassword = _passwordController.text;

    var user = await _dbHelper.findUserByEmail(email);

    if (user != null) {
      await _dbHelper.updatePassword(email, newPassword);
      Fluttertoast.showToast(msg: "Password reset successful");
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
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
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
