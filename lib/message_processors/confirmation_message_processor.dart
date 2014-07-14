part of serverManager;

class ConfirmationMessageProcessor implements MessageProcessorInterface {

  Logger _log = new Logger('ConfirmationMessageProcessor');

  Manager _manager;

  void set manager(Manager manager) {
    _manager = manager;
  }

  bool canProcess(Message message, String idClient) {
    return message is ConfirmationMessage;
  }

  void process(ConfirmationMessage message, String idClient) {
    if (_manager != null) {
      int toConfirm = message.confirmID;
      _manager.complete(toConfirm, idClient);

      _log.fine('confirmation message processed');
    }
  }
}