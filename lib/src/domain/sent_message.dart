import 'package:chatscrollview/src/chat_message.dart';
import 'package:meta/meta.dart';

import 'message_send_status.dart';

/// Исходящее сообщение с информацией о статусе отправки.
///
/// Расширяет [UserChatMessage] полями [status] и [error], чтобы UI мог
/// отображать индикатор отправки (pending / sent / failed).
@immutable
class SentMessage extends UserChatMessage {
  const SentMessage({
    required super.id,
    required super.sender,
    required super.createdAt,
    required super.updatedAt,
    required super.content,
    this.status = MessageSendStatus.pending,
    this.error,
  });

  /// Текущий статус отправки.
  final MessageSendStatus status;

  /// Ошибка отправки (заполняется только когда [status] == [MessageSendStatus.failed]).
  final Object? error;

  /// Возвращает копию с переопределёнными полями.
  SentMessage copyWith({
    int? id,
    String? sender,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    MessageSendStatus? status,
    Object? error,
  }) {
    return SentMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'SentMessage(id: $id, sender: $sender, status: $status, content: $content)';
}
