import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../chat/bloc/chat_bloc.dart';
import '../../../chat/presentation/chat_list_view.dart';
import '../../../search/presentation/search_bar_widget.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // as soon as the widget is “inited”, fire your chat-loading event:
    context.read<ChatBloc>().add(GetChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout', // Add tooltip for better accessibility
              onPressed: () {
                // Add confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<ChatBloc>().add(StopGettingChatsEvent());
                          context.read<AuthBloc>().add(SignOutEvent());

                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final user = context.select((AuthBloc bloc) =>
    bloc.state is AuthSuccess ? (bloc.state as AuthSuccess).user : null);

    if (user == null) {
      return const Center(
        child: Text(
          'No user data',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Use MediaQuery to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? double.infinity : 800,
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SearchBarWidget(),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Info',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildUserInfoItem('Name', user.name),
                        const SizedBox(height: 8),
                        _buildUserInfoItem('Email', user.email),
                        const SizedBox(height: 8),
                        _buildUserInfoItem('User ID', user.id),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ChatListWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}