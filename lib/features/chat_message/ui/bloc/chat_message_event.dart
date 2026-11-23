part of 'chat_message_bloc.dart';

/// Sealed hierarchy of chat-message events emitted by the UI layer.
///
/// The [ChatMessageBloc] translates these events into state transitions
/// (pending -> sent / failed) and owns all message-sending state so that
/// widgets stay purely presentational.
sealed class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object?> get props => [];
}

/// User tapped «Отправить» in the composer with [text].
final class ChatMessageSendRequested extends ChatMessageEvent {
  const ChatMessageSendRequested({required this.text});

  final String text;

  @override
  List<Object?> get props => [text];
}

/// User tapped «Повтор» on a failed outgoing message with [id].
final class ChatMessageRetryRequested extends ChatMessageEvent {
  const ChatMessageRetryRequested({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}