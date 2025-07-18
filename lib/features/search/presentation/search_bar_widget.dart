import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user.dart';
import '../../chat/bloc/chat_bloc.dart';
import '../bloc/search_bloc.dart';
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isSmallScreen ? double.infinity : 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchField(context),
          const SizedBox(height: 16),
          _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _controller,
        autofocus: false,

        onChanged: (query) {
          context.read<SearchBloc>().add(SearchQueryChanged(query));
        },
        decoration: InputDecoration(
          hintText: "Enter your friend's nickname...",
          hintStyle: const TextStyle(
            fontSize: 12, // Make it smaller
            color: Colors.blueGrey, // Change the color
            // You can add more properties here, e.g., fontWeight: FontWeight.w400
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              context.read<SearchBloc>().add(const SearchQueryChanged(''));
              FocusScope.of(context).unfocus();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => switch (state) {

        SearchInitial() => const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Search for friends by nickname to start chatting!",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        SearchLoading(previousResults: final prev , myUserId: final myUserId) => Container(
          constraints: const BoxConstraints(minHeight: 100),
          child: Stack(
            children: [
              if (prev != null) _SearchResults(users: prev , myUserId: myUserId , searchController: _controller,),
              const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
        SearchLoaded(users: final users , myUserId: final myUserId) => _SearchResults(users: users , myUserId: myUserId , searchController: _controller,),
        SearchError(message: final message, previousResults: final prev , myUserId: final myUserId) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prev != null) _SearchResults(users: prev , myUserId: myUserId , searchController: _controller,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<UserModel> users;
  final String myUserId;
  final TextEditingController searchController;

  const _SearchResults({required this.users , required this.myUserId , required this.searchController,});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No users found.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "@${user.nickname}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              // Add a trailing button for starting a chat.
              trailing:user.id == myUserId
                  ? null   // ← no button if it’s me
                  :  ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  final TextEditingController controller = TextEditingController();

                  // Open a bottom sheet to prompt for the first message.
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      // Use a controller to capture the user's input.
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Enter your first message',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  final String firstMessage = controller.text.trim();
                                  if (firstMessage.isNotEmpty) {
                                    final String friendId = user.id;
                                    final String friendKey= user.publicKeyInfo['publicKey'];
                                    // Dispatch the event with the user's message.
                                    context.read<ChatBloc>().add(
                                      StartNewChatEvent(
                                        firstMessage: firstMessage,
                                        friendId: friendId,
                                        friendKey: friendKey,
                                      ),
                                    );
                                    // Optionally, navigate to your chat screen using go_router here.
                                    // For example:
                                    // context.go('/chat/$friendId');
                                    Navigator.of(context).pop(); // Close the bottom sheet.
                                  }

                                  context.read<SearchBloc>().add(const SearchQueryChanged(''));
                                  searchController.clear();
                                  FocusScope.of(context).unfocus();


                                },
                                child: const Text("Start Chat"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text("Start Chat"),
              ),


            );
          },
        ),
      ),
    );
  }
}
