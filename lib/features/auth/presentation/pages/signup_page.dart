import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_pallet.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    formKey.currentState?.validate();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {

    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    } else if (state is AuthSuccess) {
      // Navigate to home page or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup Successful!'),
        ),
      );
    }

  },
  builder: (context, state) {


     if (state is AuthLoading) {
      return  const Loader();
         }

    return Form(
         key: formKey,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Signup Page'),
              const SizedBox(height: 20),
              AuthField(hintText: 'Name', controller: nameController),
              const SizedBox(height: 20),
              AuthField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 20),
              AuthField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 30),
              AuthGradientButton(buttonText: "Sign Up", onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    AuthSignUp(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
                }

              }),
          
              const SizedBox(height: 10),
          
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, LoginPage.route());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color: AppPallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  },
),
      ),
    );
  }
}
