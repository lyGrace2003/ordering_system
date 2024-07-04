import 'package:flutter/material.dart';
import 'package:ordering_system/auth/authcontroller.dart';
import 'package:ordering_system/dialog/dialog.dart';
import 'package:ordering_system/routing/router.dart';
import 'package:ordering_system/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class Loginscreen extends StatefulWidget {
  static const String route = '/';

  static const String name = 'LoginScreen';
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController email, password;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LOGIN', style: TextStyle(fontSize: 24)),
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
                  child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  GlobalRouter.I.router.go(RegisterScreen.route);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I
              .login(email.text.trim(), password.text.trim()));
    }
  }
}