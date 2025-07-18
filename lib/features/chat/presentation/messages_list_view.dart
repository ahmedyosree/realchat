import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/Local_Message.dart';
import '../bloc/chat_bloc.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      // Only rebuild when we enter the loading or failure states:
      buildWhen: (previous, current) {
        return current is StartGettingMessages
            || current is GettingMessagesFailure;
      },
      builder: (context, state) {
        if (state is StartGettingMessages) {
          return _buildChatScreen(state , context);
        } else if (state is GettingMessagesFailure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${state.error}')),
          );
        }
        // this fallback will never be shown if buildWhen blocks
        // all other states—but you can keep it as a safety net:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Scaffold _buildChatScreen(StartGettingMessages state, BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Soft light background
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ChatBloc>().add(StopGettingMessagesEvent());
            context.pop();
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.name,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '@${state.nickname}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesListWidget(
              messages: state.messages,
              myId: state.myId,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _MessageInput(state.chatId),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String chatId;
_MessageInput(this.chatId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessage(text , chatId));
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesListWidget extends StatelessWidget {
  final List<LocalMessage> messages;
  final String myId;

  const MessagesListWidget({
    super.key,
    required this.messages,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        final isMe = message.senderId == myId;
        final isSystem = message.senderId == 'System';

        return MessageBubble(
          message: message,
          isMe: isMe,
          isSystem: isSystem,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final LocalMessage message;
  final bool isMe;
  final bool isSystem;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isSystem = false,
  });

  String _friendlyTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m";
    return "now";
  }

  @override
  Widget build(BuildContext context) {
    // Common container style
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSystem
              ? Colors.yellow[200]
              : isMe
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe || isSystem
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottomRight: isMe
                ? const Radius.circular(4)
                : const Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          isSystem ? CrossAxisAlignment.center : CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.text,
                textAlign: isSystem ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: isSystem
                      ? Colors.brown[800]
                      : isMe
                      ? Colors.white
                      : Colors.black87,
                  fontSize: isSystem ? 12 : 16,
                  fontStyle: isSystem ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),

            // Always include a gap, but size it based on message type
            SizedBox(width: isSystem ? 12 : 8),

            Text(
              _friendlyTime(message.sentAt),
              style: TextStyle(
                color: isSystem
                    ? Colors.brown[600]?.withOpacity(0.7)
                    : isMe
                    ? Colors.white70
                    : Colors.grey[600],
                fontSize: isSystem ? 10 : 10,
              ),
            ),
          ],
        ),
      ),
    );

    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(child: bubble),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [bubble],
      ),
    );
  }
}
