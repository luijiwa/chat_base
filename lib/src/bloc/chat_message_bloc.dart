import 'package:bloc/bloc.dart';

import 'package:chatscrollview/src/domain/message_send_status.dart';
import 'package:chatscrollview/src/domain/send_message_use_case.dart';
import 'package:chatscrollview/src/domain/sent_message.dart';
import 'package:equatable/equatable.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

/// BLoC that owns the lifecycle of outgoing chat messages.
///
/// Responsibilities:
/// * mint stable ids for outgoing messages,
/// * create `SentMessage` records with `pending` status,
/// * delegate the actual send to [SendMessageUseCase],
/// * transition statuses to `sent` or `failed` on completion,
/// * support retry of failed messages.
///
/// Widgets only `add` events and read `state` — they never touch
/// `SendMessageUseCase`, `MessageRepository`, or raw status maps directly.
class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  ChatMessageBloc({
    required this._sendMessageUseCase,
    required int initialNextOutgoingId,
  }) : super(ChatMessageState.initial(initialNextOutgoingId)) {
    on<ChatMessageSendRequested>(_onSendRequested);
    on<ChatMessageRetryRequested>(_onRetryRequested);
  }

  final SendMessageUseCase _sendMessageUseCase;

  Future<void> _onSendRequested(
    ChatMessageSendRequested event,
    Emitter<ChatMessageState> emit,
  ) async {
    final trimmed = event.text.trim();
    if (trimmed.isEmpty) return;

    final id = state.nextOutgoingId;
    final now = DateTime.now();
    final pending = SentMessage(
      id: id,
      sender: 'Me',
      createdAt: now,
      updatedAt: now,
      content: trimmed,
      status: MessageSendStatus.pending,
    );

    // Optimistically show the message as pending.
    emit(
      state.copyWith(
        nextOutgoingId: id + 1,
        statuses: {...state.statuses, id: MessageSendStatus.pending},
        messages: {...state.messages, id: pending},
      ),
    );

    final result = await _sendMessageUseCase.send(pending);
    if (isClosed) return;
    emit(
      state.copyWith(
        statuses: {...state.statuses, id: result.status},
        messages: {
          ...state.messages,
          id: result.copyWith(updatedAt: now),
        },
      ),
    );
  }

  Future<void> _onRetryRequested(
    ChatMessageRetryRequested event,
    Emitter<ChatMessageState> emit,
  ) async {
    final existing = state.messages[event.id];
    if (existing == null) return;

    final retrying = existing.copyWith(
      status: MessageSendStatus.pending,
      error: null,
    );
    emit(
      state.copyWith(
        statuses: {...state.statuses, event.id: MessageSendStatus.pending},
        messages: {...state.messages, event.id: retrying},
      ),
    );

    final result = await _sendMessageUseCase.send(retrying);
    if (isClosed) return;
    emit(
      state.copyWith(
        statuses: {...state.statuses, event.id: result.status},
        messages: {
          ...state.messages,
          event.id: result.copyWith(updatedAt: DateTime.now()),
        },
      ),
    );
  }
}
