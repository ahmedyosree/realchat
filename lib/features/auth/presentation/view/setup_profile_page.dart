import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home');

        } else if (state is AuthFailure) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthInitial) {

          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Setup Your Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildUserEmail(),
                      const SizedBox(height: 24),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildNicknameField(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserEmail() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is AddInfo,
      builder: (context, state) {
        final email = state is AddInfo
            ? state.firebaseUser.email ?? 'No email'
            : 'Loading...';
        return ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Connected with'),
          subtitle: Text(
            email,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthBloc>().add(ChangeGmailWhileSigningInEvent()),
          ),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildNicknameField() {
    return TextFormField(
      controller: _nicknameController,
      decoration: InputDecoration(
        labelText: 'Nickname',
        prefixIcon: const Icon(Icons.badge_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        helperText: 'This will be displayed to other users',
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final firebaseUser = state is AddInfo ? state.firebaseUser : null;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: (isLoading || firebaseUser == null)
                ? null
                : () => _handleSubmit(context, firebaseUser),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Continue', style: TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }

  void _handleSubmit(BuildContext context, User firebaseUser) {
    final name = _nameController.text.trim();
    final nickname = _nicknameController.text.trim();

    if (name.isEmpty || nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }
    final nicknameRegex = RegExp(r'^[A-Za-z0-9_]+$');
    if (!nicknameRegex.hasMatch(nickname)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nickname can only contain letters, numbers, and underscores.'),
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(
      AddInfoEvent(
        firebaseUser: firebaseUser,
        name: name,
        nickname: nickname,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
}