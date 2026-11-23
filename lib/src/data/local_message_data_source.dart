import 'package:chatscrollview/src/domain/message_send_status.dart';
import 'package:chatscrollview/src/domain/sent_message.dart';

/// Локальный асинхронный источник отправки сообщений.
///
/// Имитирует сетевую операцию через [Future.delayed]. Детерминированно
/// чередует результат: первый вызов — ошибка, второй — успех, третий — ошибка
/// и так далее. Это позволяет наглядно продемонстрировать все три статуса
/// (`pending` → `failed` → `sent`) в UI без реального сервера.
class LocalMessageDataSource {
  LocalMessageDataSource({this.delay = const Duration(seconds: 2)});

  /// Задержка перед "отправкой" (имитация сетевого round-trip).
  final Duration delay;

  int _attempt = 0;

  /// "Отправляет" [message] асинхронно.
  ///
  /// Возвращает сообщение со статусом `sent` или бросает исключение
  /// (которое репозиторий маппит в `failed`), в зависимости от порядкового
  /// номера вызова.
  Future<SentMessage> send(SentMessage message) async {
    await Future<void>.delayed(delay);
    _attempt++;

    if (_attempt.isOdd) {
      throw LocalSendException('Сеть недоступна (демо-ошибка №$_attempt)');
    }

    return message.copyWith(status: MessageSendStatus.sent);
  }
}

/// Исключение, выбрасываемое [LocalMessageDataSource] при демо-ошибке.
class LocalSendException implements Exception {
  const LocalSendException(this.message);
  final String message;
}
