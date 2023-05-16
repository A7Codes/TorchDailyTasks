import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torchdailytasks/Helpers/email_service.dart';
import '../Providers/TaskData.dart';
import '../main.dart';
import 'CredentialsDialog.dart';

class EmailDialog extends StatefulWidget {
  const EmailDialog({Key? key}) : super(key: key);

  @override
  _EmailDialogState createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  List<String> _emails = [
    'deaa@torchcorp.com',
    'philippe@torchcorp.com',
    'taif.i@torchcorp.com',
    'ali.saad@torchcorp.com',
    'ahmed.saad@torchcorp.com',
  ];

  List<String> _selectedEmails = [];

  void _onEmailSelected(String email, bool selected) {
    if (selected) {
      Provider.of<TaskData>(context, listen: false).addRecipient(email);
      setState(() {
        _selectedEmails.add(email);
      });
    } else {
      Provider.of<TaskData>(context, listen: false).recipients.remove(email);
      setState(() {
        _selectedEmails.remove(email);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Tasks via Email'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final email in _emails)
              CheckboxListTile(
                title: Text(email),
                value: _selectedEmails.contains(email),
                onChanged: (selected) {
                  _onEmailSelected(email, selected ?? false);
                },
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final un = prefs.getString('un');
            final pa = prefs.getString('pa');
            if (un != null && pa != null) {
              sendTasksByEmail(
                  context,
                  un,
                  pa,
                  Provider.of<TaskData>(context, listen: false).tasks,
                  Provider.of<TaskData>(context, listen: false).recipients);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CredentialsAlertDialog();
                },
              );
            }
          },
          child: const Text('SEND NOW'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
