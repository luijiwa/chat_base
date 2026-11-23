part of 'chat_message_bloc.dart';

/// Current state of the chat-message sending lifecycle.
///
/// Holds per-message delivery statuses and the underlying [SentMessage]
/// objects (needed for retries and UI rendering). `nextOutgoingId` mints
/// stable ids for newly composed outgoing messages.
class ChatMessageState extends Equatable {
  const ChatMessageState({
    required this.statuses,
    required this.messages,
    required this.nextOutgoingId,
  });

  /// Initial state — no outgoing messages yet, id counter starts at [nextOutgoingId].
  factory ChatMessageState.initial(int nextOutgoingId) => ChatMessageState(
    statuses: <int, MessageSendStatus>{},
    messages: <int, SentMessage>{},
    nextOutgoingId: nextOutgoingId,
  );

  /// Delivery status per outgoing message id.
  final Map<int, MessageSendStatus> statuses;

  /// Outgoing messages by id (kept for retry and UI rendering).
  final Map<int, SentMessage> messages;

  /// Next id to assign to a newly composed outgoing message.
  final int nextOutgoingId;

  /// Status of the message with [id], or `null` if unknown.
  MessageSendStatus? statusOf(int id) => statuses[id];

  /// The [SentMessage] with [id], or `null` if unknown.
  SentMessage? messageOf(int id) => messages[id];

  ChatMessageState copyWith({
    Map<int, MessageSendStatus>? statuses,
    Map<int, SentMessage>? messages,
    int? nextOutgoingId,
  }) {
    return ChatMessageState(
      statuses: statuses ?? this.statuses,
      messages: messages ?? this.messages,
      nextOutgoingId: nextOutgoingId ?? this.nextOutgoingId,
    );
  }

  @override
  List<Object?> get props => [statuses, messages, nextOutgoingId];
}
