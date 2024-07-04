import 'package:flutter/material.dart';
import 'package:ordering_system/auth/authcontroller.dart';
import 'package:ordering_system/dialog/dialog.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';

  static const String name = 'RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController firstname, lastname, email, password;

   @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    firstname = TextEditingController();
    lastname = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('REGISTER', style: TextStyle(fontSize: 24)),
              TextField(
                controller: firstname,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastname,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,future: AuthController.I.register(
        email.text.trim(),
        password.text.trim(),
        firstname.text.trim(),
        lastname.text.trim(),
      ));
    } 
  }
}
