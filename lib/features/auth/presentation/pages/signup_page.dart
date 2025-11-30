import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signup Page'),
            const SizedBox(height: 20),
            AuthField(hintText: 'Name', controller: TextEditingController()),
            const SizedBox(height: 20),
            AuthField(hintText: 'Email', controller: TextEditingController()),
            const SizedBox(height: 20),
            AuthField(
              hintText: 'Password',
              controller: TextEditingController(),
              isObscureText: true,
            ),
             SizedBox(height: 30,),
             AuthGradientButton(buttonText: "Sign Up", onPressed: (){}),
            RichText(text: TextSpan(text: "Don't have an account"))
          ],
        ),
      ),
    );
  }
}
