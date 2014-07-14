part of serverManager;

class ConfirmableMessageProcessor implements MessageProcessorInterface {

  Logger _log = new Logger('ConfirmableMessageProcessor');

  Manager _manager;

  void set manager(Manager manager) {
    _manager = manager;
  }

  bool canProcess(Message message, String idClient) {
    return message.confirmableFlag;
  }

  void process(Message message, String idClient) {
    if (_manager != null) {
      if (message.id != null) {
        ConfirmationMessage confirmation = new ConfirmationMessage(_manager.nextMessageId);
        confirmation.confirmID = message.id;
        _manager.send(confirmation, idClient);

        _log.fine('confirmable message processed');
      }
    }
  }
}