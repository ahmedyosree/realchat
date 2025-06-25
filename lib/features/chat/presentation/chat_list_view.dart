import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/chat.dart';
import '../bloc/chat_bloc.dart';


class ChatListWidget extends StatelessWidget {
  const ChatListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(

      builder: (context, state) {
        if (state is GettingChatsFailure) {
          return Center(
            child: Text(
              'Failed to load chats: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is StartGettingChats) {
          final chats = state.chats;
          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return _ChatItem(chat: chat, onTap: () {
                // TODO: Add navigation or selection logic here
              });
            },
          );
        }
        // Show loading state or initial
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ChatItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback? onTap;

  const _ChatItem({Key? key, required this.chat, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show first 2 people names or IDs except current user (you may need to provide current user id)
    final subtitle = chat.people.join(', ');
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(
          chat.people.isNotEmpty
              ? chat.people.first.substring(0, 1).toUpperCase()
              : '?',
        ),
      ),
      title: Text(subtitle),
      subtitle: Text('Started: ${_friendlyTime(chat.chatStartIn)}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  String _friendlyTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "now";
  }
}