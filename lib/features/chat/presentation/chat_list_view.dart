import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:realchat/core/models/chat_preview.dart';
import '../bloc/chat_bloc.dart';


class ChatListWidget extends StatelessWidget {
  const ChatListWidget({super.key});

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
          final chats = state.chatPreview;
          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chatPreview = chats[index];
              return _ChatItem(chatPreview: chatPreview, onTap: () {
                context.go('/messages');
                context.read<ChatBloc>().add(GetMessagesEvent(chatPreview.chatId, chatPreview.name, chatPreview.nickname));
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
  final ChatPreview chatPreview;
  final VoidCallback? onTap;

  const _ChatItem({
    Key? key,
    required this.chatPreview,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 1) Avatar
            CircleAvatar(
              radius: 24,

              backgroundColor: Colors.grey.shade200,
              child:  Icon(Icons.person, size: 28, color: Colors.grey.shade600)
                  ,
            ),

            const SizedBox(width: 12),

            // 2–4) Name+time, last message, nickname
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                            Text(
                              chatPreview.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Nickname
                            Text(
                              chatPreview.nickname,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _friendlyTime(chatPreview.sentAt),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Last message preview
                  Text(
                    chatPreview.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),

                  const SizedBox(height: 4),


                ],
              ),
            ),

            // 5) Chevron
            const Icon(Icons.chevron_right, size: 24, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _friendlyTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays  > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "now";
  }
}
