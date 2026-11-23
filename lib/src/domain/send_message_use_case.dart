import 'package:chatscrollview/src/domain/message_send_status.dart';

import 'message_repository.dart';
import 'sent_message.dart';

/// Вариативная ошибка валидации исходящего сообщения.
class MessageValidationException implements Exception {
  const MessageValidationException(this.message);
  final String message;
}

/// Инкапсулирует бизнес-логику отправки сообщения.
///
/// Валидирует текст (не пустой).
/// Делегирует фактическую отправку [MessageRepository].
/// Маппит исключения репозитория в результат с [MessageSendStatus.failed].
class SendMessageUseCase {
  SendMessageUseCase(this._repository);

  final MessageRepository _repository;

  /// Отправляет [message].
  ///
  /// Выбрасывает [MessageValidationException], если текст пуст.
  /// Возвращает `SentMessage` со статусом `sent` или `failed`.
  Future<SentMessage> send(SentMessage message) async {
    if (message.content.trim().isEmpty) {
      throw const MessageValidationException(
        'Текст сообщения не должен быть пустым',
      );
    }

    try {
      return await _repository.sendMessage(message);
    } on Object catch (error) {
      return message.copyWith(status: MessageSendStatus.failed, error: error);
    }
  }
}
