// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signIn(
                    _emailController.text, _passwordController.text);
              },
              child: Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signUp');
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
