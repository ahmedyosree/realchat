import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/widgets/auth_button.dart';
import '../../../../core/constants/widgets/auth_text_field.dart';
import '../../../../core/constants/widgets/logo.dart';
import '../../../../core/constants/widgets/social_login_button.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,

      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AutoCrossFadeLogos(),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.person,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _nicknameController,
                      label: 'Nickname',
                      icon: Icons.badge,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your nickname';
                        }
                        // Add regex validation ONLY HERE
                        if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(value)) {
                          return 'Only letters, numbers, and underscores are allowed.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your email'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your password'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: AuthButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              RegisterWithEmailEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                name: _nameController.text.trim(),
                                nickname: _nicknameController.text.trim(),
                              ),
                            );
                          }
                        },
                        text: 'REGISTER',
                      ),
                    ),

                    const SizedBox(height: 20),
                    if (isLargeScreen)
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('OR'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      )
                    else
                      const Divider(),
                    const SizedBox(height: 20),
                    GoogleSignInButton(
                      onPressed: () => context.read<AuthBloc>().add(SignInWithGoogleEvent()),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
