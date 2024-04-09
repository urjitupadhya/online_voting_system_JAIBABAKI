import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: ContactUsForm(),
    );
  }
}

class ContactUsForm extends StatefulWidget {
  @override
  _ContactUsFormState createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Your Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              _sendEmail(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _sendEmail(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    final smtpServer = gmail('urjitupadhyayuu@gmail.com', '123456');

    final messageToSend = Message()
      ..from = Address(email, name)
      ..recipients.add('systemonIinevoting869@gmail.com') // Replace with your business email
      ..subject = 'Query from $name'
      ..text = message;

    try {
      final sendReport = await send(messageToSend, smtpServer);
      print('Message sent: ${sendReport.toString()}');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Form Submitted'),
            content: Text('Thank you for contacting us! We will get back to you soon.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      _clearFormFields();
    } catch (e) {
      print('Error occurred while sending email: $e');
      // Handle error scenario, e.g., show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _clearFormFields() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }
}
