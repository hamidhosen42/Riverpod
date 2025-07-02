import 'package:client/core/theme/app_color.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_gradient_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30.0),
              CustomField(hintText: "Email", controller: emailController),
              const SizedBox(height: 15.0),
              CustomField(
                hintText: "Password",
                controller: passController,
                isObscureText: true,
              ),
              const SizedBox(height: 20.0),
              AuthGradientButton(buttonText: "Sign In", onTap: () {}),
              const SizedBox(height: 20.0),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: AppColor.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}