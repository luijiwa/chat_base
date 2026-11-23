import 'package:chatscrollview/src/data/local_message_data_source.dart';
import 'package:chatscrollview/src/domain/message_repository.dart';
import 'package:chatscrollview/src/domain/message_send_status.dart';
import 'package:chatscrollview/src/domain/sent_message.dart';

/// Реализация [MessageRepository] поверх локального асинхронного источника.
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._dataSource);

  final LocalMessageDataSource _dataSource;

  @override
  Future<SentMessage> sendMessage(SentMessage message) async {
    try {
      return await _dataSource.send(message);
    } on Object catch (error) {
      return message.copyWith(status: MessageSendStatus.failed, error: error);
    }
  }
}
