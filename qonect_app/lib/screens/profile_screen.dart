import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: user == null
          ? Center(child: Text('No user signed in'))
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text('Email: ${user.email}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signOut();
                      Navigator.pushReplacementNamed(context, '/signIn');
                    },
                    child: Text('Sign Out'),
                  ),
                ],
              ),
            ),
    );
  }
}
