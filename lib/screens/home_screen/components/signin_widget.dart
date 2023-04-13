import 'package:crypto_exchange_app/custom_widgets/custom_elevated_iconButton.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/helper_methods.dart';
import '../widgets/utils.dart';
import '/custom_widgets/custom_image.dart';
import '../password_reset_screen.dart';

class SigninWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SigninWidget({super.key, required this.onClickedSignIn});

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const CustomImage(imagePath: 'assets/images/smile.png', size: 80),
              const SizedBox(height: 24),
              Text('Welcome', textAlign: TextAlign.center, style: theme.textTheme.displayMedium),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (input) {
                  if (input == null) {
                    return 'Please enter your email';
                  } else if (EmailValidator.validate(input) == false) {
                    return 'Please enter a valid email';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _passwordController,
                autofocus: false,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _togglePasswordVisibility(),
                    child: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                textInputAction: TextInputAction.done,
                obscureText: _isPasswordObscured,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Please enter your password';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PasswordResetScreen(),
                )),
                child: Text(
                  'Forgot password?',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleMedium!.apply(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 18),
              CustomElevatedIconBtn(
                  title: 'Sign In',
                  icon: Icons.email_rounded,
                  onPressed: () async {
                    final bool isFormValid = _formKey.currentState!.validate();
                    if (!isFormValid) return;

                    try {
                      await signIn(context, email: _emailController.text, password: _passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Utils.showSnackBar('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        Utils.showSnackBar('Wrong password provided for that user.');
                      } else {
                        Utils.showSnackBar(e.message);
                      }
                      Navigator.of(context).pop();
                    }
                  }),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: 'No Account? ', style: theme.textTheme.titleMedium),
                    TextSpan(
                        text: 'Sign Up ',
                        recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn,
                        style: theme.textTheme.titleLarge!.apply(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green,
                          color: Colors.green,
                        )),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}