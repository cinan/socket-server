part of serverManager;

class PingMessageProcessor implements MessageProcessorInterface {

  Logger _log = new Logger('PingMessageProcessor');

  Manager _manager;

  void set manager(Manager manager) {
    _manager = manager;
  }

  bool canProcess(Message message, String idClient) {
    return message is PingMessage;
  }

  void process(Message message, String idClient) {
    if (_manager != null) {
      _manager.send(new PongMessage(), idClient);

      _log.fine('ping processed');
    }
  }
}