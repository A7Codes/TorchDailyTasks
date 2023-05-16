//Dialogs
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsAlertDialog extends StatefulWidget {
  @override
  _CredentialsAlertDialogState createState() => _CredentialsAlertDialogState();
}

class _CredentialsAlertDialogState extends State<CredentialsAlertDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Credentials not Set !'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Handle submission here
            print('Username: ${_usernameController.text}');
            print('Password: ${_passwordController.text}');
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString("un", _usernameController.text);
            prefs.setString("pa", _passwordController.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Now Send Email")));
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
