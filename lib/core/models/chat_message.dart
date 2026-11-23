import 'package:chatscrollview/src/chat_scroll/chat_scroll_common.dart';
import 'package:meta/meta.dart';

@immutable
sealed class ChatMessage implements IChatMessage {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  final int id;

  @override
  final String sender;

  final String chatId;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;
}

/// A system-authored message — service notifications, join/leave notices,
/// channel events. `sealed`-pattern leaf of [ChatMessage].
class SystemChatMessage extends ChatMessage {
  const SystemChatMessage({
    required super.id,
    required super.sender,
    required super.createdAt,
    required super.updatedAt,
    required this.content,
    super.chatId = 'room1',
  });

  /// The content of the system message.
  final String content;
}

/// A user-authored message. `sealed`-pattern leaf of [ChatMessage].
class UserChatMessage extends ChatMessage {
  const UserChatMessage({
    required super.id,
    required super.sender,
    super.chatId = 'room1',
    required super.createdAt,
    required super.updatedAt,
    required this.content,
  });

  /// The content of the user message.
  final String content;
}
