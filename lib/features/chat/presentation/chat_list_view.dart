import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:realchat/core/models/chat_preview.dart';
import '../bloc/ChatMessagesBloc/message_bloc.dart';
import '../bloc/ChatOverviewBloc/chat_bloc.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) {
        return current is StartGettingChats || current is GettingChatsFailure;
      },
      builder: (context, state) {
        if (state is GettingChatsFailure) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Failed to load chats: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is StartGettingChats) {
          final chats = state.chatPreview;
          final myId = state.myId;
          if (chats.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No conversations yet\nStart a new chat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final chatPreview = chats[index];
              return _ChatItem(
                chatPreview: chatPreview,
                myId: myId,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  context.push('/messages');
                  context.read<MessageBloc>().add(GetMessagesEvent(
                    chatPreview.chatId,
                    chatPreview.name,
                    chatPreview.nickname,
                  ));
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ChatItem extends StatelessWidget {
  final ChatPreview chatPreview;
  final String myId;
  final VoidCallback? onTap;

  const _ChatItem({
    Key? key,
    required this.chatPreview,
    required this.myId,
    this.onTap,
  }) : super(key: key);

  // Helper to determine message color
  Color _getMessageColor() {
    if (chatPreview.senderId == myId) {
      return Colors.green.shade700; // Your messages
    } else if (chatPreview.senderId == "System") {
      return Colors.orange.shade700; // System messages
    }
    return Colors.grey.shade700; // Other messages
  }

  // Determine prefix text
  String _getMessagePrefix() {
    if (chatPreview.senderId == myId) return "You: ";
    if (chatPreview.senderId == "System") return "System: ";
    return "${chatPreview.nickname}: ";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.05),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAvatarColor(chatPreview.name),
              ),
              child: Center(
                child: Text(
                  chatPreview.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatPreview.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        _friendlyTime(chatPreview.sentAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Message preview
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _getMessagePrefix(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade700,
                                ),
                              ),
                              TextSpan(
                                text: chatPreview.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getMessageColor(),
                                  fontWeight: chatPreview.senderId == "System"
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 24, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // Generate consistent avatar color based on name
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
    ];
    final index = name.codeUnits.fold(0, (sum, code) => sum + code) % colors.length;
    return colors[index];
  }

  // Your existing time formatting function
  String _friendlyTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "now";
  }
}