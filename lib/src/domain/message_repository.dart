import 'sent_message.dart';

/// Контракт репозитория отправки сообщений.
abstract class MessageRepository {
  /// Отправляет [message] и возвращает результат с финальным статусом
  /// ([MessageSendStatus.sent] при успехе, [MessageSendStatus.failed] при ошибке).
  Future<SentMessage> sendMessage(SentMessage message);
}
