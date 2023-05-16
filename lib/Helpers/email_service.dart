import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:torchdailytasks/task.dart';

Future<void> sendTasksByEmail(BuildContext context, String un, String pa,
    List<Task> tasks, List<String> recipients) async {
  String username = '';
  String password = '';

  username = un;
  password = pa;

  final smtpServer = SmtpServer(
    'smtp.hostinger.com',
    ssl: true,
    port: 465,
    username: username,
    password: password,
  );

  final message = Message()
    ..recipients.clear()
    ..from = Address(username, username)
    ..recipients.addAll(recipients)
    ..subject = 'Daily Tasks Report'
    ..html = 'Here is the list of tasks:<br><br>' + tasksToString(tasks);
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

String tasksToString(List<Task> tasks) {
  String tableHeader =
      "<tr><th>Task Number</th><th>Description</th><th>Status</th><th>Date</th></tr>";
  String tableRows = tasks.map((task) {
    return '<tr><td>${task.taskNumber}</td><td>${task.description}</td><td>${task.status}</td><td>${task.date}</td></tr>';
  }).join('');

  return "<table border='1' cellspacing='0' cellpadding='5'>$tableHeader$tableRows</table>";
}
