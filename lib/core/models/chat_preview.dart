/// /// A model for displaying chats with the latest message in the chat.
class ChatPreview {
// Fields from LocalMessage
final String chatId;
final String senderId;
final String text;
final DateTime sentAt;
final String name;
final String nickname;

  ChatPreview({
  required this.chatId,
  required this.senderId,
  required this.text,
  required this.sentAt,
    required this.name,
    required this.nickname,
});
}