import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/widgets/auth_button.dart';
import '../../../../core/constants/widgets/auth_text_field.dart';
import '../../../../core/constants/widgets/social_login_button.dart';
import '../../../chat/bloc/chat_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.button),
            onPressed: () {
              // Add language change functionality
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("5");
          if (state is AuthLoading) {
            print("6");
            context.push('/');
          }

          if (state is AuthSuccess) {
            print("7");
            context.go('/home');
            if (state.welcomeMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.welcomeMessage!)),
              );
            }

          } else if (state is AddInfo) {
            print("8");
            context.push('/addinfo');

          }
          else if (state is AuthFailure) {
            print("9");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }else if (state is AuthInitial) {
            print("9.5");
            context.go('/login');
          }
        },

        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Icon(Icons.lock, size: 80, color: AppColors.button),
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
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Add forgot password functionality
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: AppColors.button),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                SignInWithEmailEvent(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                          text: 'LOGIN',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () => context.push('/signup'),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
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
                          onPressed: () {
                            context.read<AuthBloc>().add(SignInWithGoogleEvent());
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

